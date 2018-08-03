import UIKit

class IdentifyCadences: UIViewController {
    private var selectedTonics = SelectedTonics.sharedInstance
    private var selectedIntervals = SelectedIntervals.sharedInstance
    private var runningStaff : Staff?
    private var lastChordDescription : String
    private var keyIndex : Int = 0
    
    @IBOutlet weak var uiViewStaff: StaffView!
    
    @IBOutlet weak var fourNoteChords: UISwitch!
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var showRootPos: UISwitch!
    @IBOutlet weak var multipleKeys: UISwitch!
    
    required init?(coder aDecoder: NSCoder) {
        lastChordDescription = ""
        super.init(coder: aDecoder)
    } 
    
    @IBAction func showChord(sender: AnyObject) {
        result.text = lastChordDescription
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: Selector("settings"))
        print("cadences loaded Sunday..")
        let time = UInt32(NSDate().timeIntervalSinceReferenceDate)
        // ??srand(time)
        //arc4random(time)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func settings() {
        performSegue(withIdentifier: "segueToSettings", sender: nil)
    }
    
    func getStaff() -> Staff {
        //this treatment of staff keeps the sounds from instruments alive until the next 'play' when
        //the previous staff gets destroyed (deinit'd). Staff keeps a reference to notes that keeps them alive
        //(and therefore attached to the audio engine)
        if self.runningStaff != nil {
            self.runningStaff!.forceStop()
        }
        self.runningStaff = Staff()
        self.runningStaff!.setTempo(tempo: Double(1))
        return runningStaff!
    }

    @IBAction func nextClicked(sender: AnyObject) {
        result.text = ""
        let staff = self.getStaff()
        let inst1 = Instrument(midiPresetId: AvailableInstruments.getSelectedInstrument())
        let voiceTreble : Voice = Voice(instr: inst1, clef: CLEF_TREBLE)
        let voiceBass : Voice = Voice(instr: inst1, clef: CLEF_BASS)
        staff.addVoice(voice: voiceTreble)
        staff.addVoice(voice: voiceBass)
        let notesInChord = 3
        
        //figure out the notes we can use at this root offset in the scale
        let scaleOffsets = Scale(type: SCALE_MAJOR).offsets
        
        //pick a key
        var key : KeySignature
        if (self.multipleKeys.isOn) {
            key = KeySignature.getCommonKeys()[self.keyIndex]
            if (keyIndex < KeySignature.getCommonKeys().count - 1) {
                keyIndex += 1
            }
            else {
                keyIndex = 0
            }
            
        }
        else {
            key = SelectedKeys.getSelectedKey()
        }
        let base = key.getRootNote()
        
        let tonicChord:Chord = Chord(root: base, type: CHORD_MAJOR, seventh: fourNoteChords.isOn)
        voiceTreble.add(object: tonicChord)
        voiceBass.add(object: Note(noteValue: base - 1 * OCTAVE_OFFSET))
        
        // pick a random offset in the scale as the chord root
        let scaleNote = scaleOffsets[Int(arc4random()) % scaleOffsets.count]
        let chType: Int = Scale.chordTypeAtPosition(pos: scaleNote)
        var trebleChord:Chord = Chord(root: base + scaleNote, type: chType, seventh: fourNoteChords.isOn)

        if showRootPos.isOn {
            voiceTreble.add(object: voiceTreble.putOnStaff(chord: trebleChord))
            var bassNote = base + scaleNote - 1 * OCTAVE_OFFSET
            if (bassNote > MIDDLE_C) {
                bassNote -= OCTAVE_OFFSET
            }
            voiceBass.add(object: Note(noteValue: bassNote))
        }
        
        //remove a non root note from the treble chord to add it to the base chord
        let removeIndex = 1 + Int(arc4random()) % (trebleChord.notes.count - 1)
        let removedFromTreble = trebleChord.notes[removeIndex].noteValue
        trebleChord = Chord.removeNote(chord: trebleChord, noteNum: removeIndex)

        var inversions = Int(arc4random()) % notesInChord
        if inversions > 0 {
            for i in 0...inversions-1 {
                trebleChord = Chord.invert(chord: trebleChord)
            }
        }
        
        var baseNotes : [Int] = []
        baseNotes.append(base + scaleNote - 2 * OCTAVE_OFFSET)  // add the chord root
        baseNotes.append(removedFromTreble - 2 * OCTAVE_OFFSET) //add the note remvoed from the treble
        var bassChord : Chord = Chord(noteValues: baseNotes)

        //make the root not always the lowest bass chord note
        inversions = Int(arc4random()) % baseNotes.count
        if (inversions > 0) {
            for _ in 0...inversions-1 {
                bassChord = Chord.invert(chord: bassChord)
            }
        }
        
        voiceTreble.add(object: voiceTreble.putOnStaff(chord: trebleChord))
        voiceBass.add(object: voiceBass.putOnStaff(chord: bassChord))
        
        lastChordDescription = "\(Chord.romanNumeralNotation(note: scaleNote))"
        staff.play()
        self.uiViewStaff.setStaff(staff: staff, key: key)
        self.uiViewStaff.setNeedsDisplay()
    }
    
    @IBAction func nextClicked_test(sender: AnyObject) {
        let staff = self.getStaff()
        let inst1 = Instrument(midiPresetId: AvailableInstruments.getSelectedInstrument())
        let voice1 : Voice = Voice(instr: inst1, clef: CLEF_TREBLE)
        let voice2 : Voice = Voice(instr: inst1, clef: CLEF_BASS)
        staff.addVoice(voice: voice1)
        //staff.addVoice(voice: voice1, voice: voice2)
        
        voice1.add(object: Note(noteValue: MIDDLE_C + 0))
        voice1.add(object: Note(noteValue: MIDDLE_C - 3))
        voice2.add(object: Note(noteValue: MIDDLE_C + 0))
        voice2.add(object: Note(noteValue: MIDDLE_C + 4))
        //voice1.add(Rest())
        voice2.add(object: Rest())
        
        staff.play()
        self.uiViewStaff.setStaff(staff: staff, key: SelectedKeys.getSelectedKey())
        self.uiViewStaff.setNeedsDisplay()
    }

    @IBAction func scaleClicked(sender: AnyObject) {
        let staff = self.getStaff()
        let inst1 = Instrument(midiPresetId: AvailableInstruments.getSelectedInstrument())
        let voice1 : Voice = Voice(instr: inst1, clef: CLEF_AUTO)
        staff.addVoice(voice: voice1)
        //let voice2 : Voice = Voice(instr: inst1)
        //staff.addVoice(voice2)
        
        let scale: Scale = Scale(type: SCALE_MAJOR)
        var base = 60
        for _ in 0...0 {
            for offset in scale.offsets {
                let chType: Int = Scale.chordTypeAtPosition(pos: offset)
                print("offset \(offset) type \(chType)")
                let chord:Chord = Chord(root: base + offset, type: chType, seventh: false)
                voice1.add(object: chord)
                //voice2.addSound(Note(note: base + offset - 12, duration : NOTE_QTR))
            }
            base += 12
        }
        staff.play()
        self.uiViewStaff.setStaff(staff: staff, key: SelectedKeys.getSelectedKey())
        self.uiViewStaff.setNeedsDisplay()
    }
    
    @IBAction func cadencesClicked(sender: AnyObject) {
        let staff = self.getStaff()
        let inst1 = Instrument(midiPresetId: AvailableInstruments.getSelectedInstrument())
        let inst2 = Instrument(midiPresetId: AvailableInstruments.getSelectedInstrument())
        let voice1 : Voice = Voice(instr: inst1, clef: CLEF_AUTO)
        let voice2 : Voice = Voice(instr: inst2, clef: CLEF_AUTO)
        staff.addVoice(voice: voice1)
        staff.addVoice(voice: voice2)
        let base : Int = 60 
        let progression = [0, 5, 7, 0]
        
        for tonic in 0...0 {
            var lastChord : Chord?
            for chordIndex in progression {
                let root = base + tonic + chordIndex
                let chordType = Scale.chordTypeAtPosition(pos: chordIndex)
                //println("base \(base) index \(chordIndex) type \(chordType)")
                var chord : Chord = Chord(root: root, type: chordType, seventh: false)
                if lastChord != nil {
                    chord = Chord.voiceLead(chord1: lastChord!, chord2: chord)
                }
                //var chordNotes : [Sound] = chord.blockBass()
                voice1.add(object: Rest())
                voice2.add(object: Note(noteValue: root - 12))
                voice1.add(object: chord)
                voice2.add(object: Rest())
                lastChord = chord
            }
            for i in 0...3 {
                voice1.add(object: Rest())
                voice2.add(object: Rest())
            }
        }
        staff.play()
        self.uiViewStaff.setStaff(staff: staff, key: SelectedKeys.getSelectedKey())
        self.uiViewStaff.setNeedsDisplay()
    }
}
