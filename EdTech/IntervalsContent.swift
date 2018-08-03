import UIKit
let att = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]

class IntervalsContent: UIViewController {
    
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    @IBOutlet weak var uiViewStaff: StaffView!
    @IBOutlet weak var StaffView_third: StaffView!
    @IBOutlet weak var uiViewGraph1: GraphView!
    @IBOutlet weak var uiViewGraph2: GraphView!

    @IBOutlet weak var btn_5: UIButton!
    @IBOutlet weak var btn_3: UIButton!

    var runningStaff : Staff?
    private var tonics = [60, 64, 67, 55, 53, 51]
    private var top_tonic_index = 0
    private var btm_tonic_index = 0
    var topic_selected : Int = 0
    private var direction = 1
    var tempo = 0.5 //self.sliderSpeed.maximumValue - self.sliderSpeed.value
    public var instrument_names : [String] = []
    public var keys = ["A"]
    private var key : KeySignature = SelectedKeys.getKeyByName(name: "C")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var html5 = "<html><body>TOPIC:"+String(self.topic_selected)+"</html></body>"
        var html_2nd = html5
        print ("topic ", self.topic_selected)
        if self.topic_selected == 10 {
            html5 = """
<html>
<body>
<font face="arial" color="black">

<h3>The Perfect Fifth Interval</h3>
<font face="arial" color="black">
An interval is defined as the distance in pitch between two notes. We use the word <b>interval</b> to describe how close or how far apart two notes are from each other.
<br><br>Perfect fifth intervals are called perfect because the ratios of their frequencies are simple whole numbers. Pythagoras was the first person from the West to understand the math behind the perferct fifth. Here is the theme for the film 2001 using a perfect fifth
<a href="https://www.youtube.com/watch?v=e-QFj59PON4&feature=youtu.be&t=15">here</a>.
</font>
</body>
</html>
"""
            html_2nd = """
<html>
<body>
<font face="arial" color="black">

<h3>The Major Third Interval</h3>
<font face="arial" color="black">
Major third intervals are using notes from the major scale. A major 3rd is made of 4 semi-tones (ie : 2 whole-tones). Major and minor thirds are different and we will cover the minor third later. You can hear a major third <a href="https://www.youtube.com/watch?v=e-QFj59PON4&feature=youtu.be&t=15">here</a>.
</font>
</body>
</html>
"""
        }
        if self.topic_selected == 11 {
            html5 = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Perfect Fourth Interval</h3>
            <font face="arial" color="black">
            The perfect fourth is a perfect interval like the unison, octave, and perfect fifth, and it is a sensory consonance. In common practice harmony, however, it is considered a stylistic dissonance in certain contexts, namely in two-voice textures and whenever it appears above the bass
            </font>
            </body>
            </html>
            """
            html_2nd = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Major Second Interval</h3>
            <font face="arial" color="black">
            The major second was historically considered one of the most dissonant intervals of the diatonic scale, although much 20th-century music saw it reimagined as a consonance. It is common in many different musical systems, including Arabic music, Turkish music and music of the Balkans, among othersa
            </font>
            </body>
            </html>
            """
        }
        if self.topic_selected == 12 {
            html5 = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Seventh Interval</h3>
            <font face="arial" color="black">
            The seventh interval takes the falttened seventh note in the scale. Adding the seventh to the dominant triad makes a dominant seventh chord which, in turn, is an important chord in almost all music structure.
            </font>
            </body>
            </html>
            """
            html_2nd = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Minor Third Interval</h3>
            <font face="arial" color="black">
            The minor 3rd is arrvied at by flattening the 3rd from the major third. The minor third makes a 'sad' interval rather than the 'happy' interval or the majpr third.
            </font>
            </body>
            </html>
            """
        }
        if self.topic_selected == 20 {
            html5 = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Major Triad</h3>
            <font face="arial" color="black">
            A major triad is a 3-note chord that has a root note, a major third above this root, and a perfect fifth above this root note. When a chord has these three notes alone, it is called a major triad.
            
            </font>
            </body>
            </html>
            """
            html_2nd = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Minor Triad</h3>
            <font face="arial" color="black">
            A minor chord ( play D minor chord (help. · info)) is a chord having a root, a minor third, and a perfect fifth. When a chord has these three notes alone, it is called a minor triad. Some minor triads with additional notes, such as the minor seventh chord, may also be called minor chords.
            </font>
            </body>
            </html>
            """
        }
        if self.topic_selected == 21 {
            html5 = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Seventh Chord</h3>
            <font face="arial" color="black">
            A seventh chord is a chord consisting of a triad plus a note forming an interval of a seventh above the chord's root. When not otherwise specified, a "seventh chord" usually means a dominant seventh chord: a major triad together with a minor seventh.
            
            </font>
            </body>
            </html>
            """
            html_2nd = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Major Seventh</h3>
            <font face="arial" color="black">
            is a seventh chord where the "third" note is a major third above the root, and the "seventh" note is a major seventh above the root (a fifth above the third note)
            </font>
            </body>
            </html>
            """
        }
        if self.topic_selected == 30 {
            html5 = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Perfect Cadence</h3>
            <font face="arial" color="black">
            A perfect cadence is a progression from V to I in major keys, and V to i in minor keys. This is generally the strongest type of cadence and often found at structurally defining moments.[
            
            </font>
            </body>
            </html>
            """
            html_2nd = """
            <html>
            <body>
            <font face="arial" color="black">
            
            <h3>The Plagal Cadence</h3>
            <font face="arial" color="black">
            Also known as the "Amen Cadence" because of its frequent setting to the text "Amen" in hymns. William Caplin disputes the existence of plagal cadences in music of the classical era: "An examination of the classical repertory reveals that such a cadence rarely exists.
            </font>
            </body>
            </html>
            """
        }
        
        var data = Data(html5.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            textView1.attributedText = attributedString
        }
        data = Data(html_2nd.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            textView2.attributedText = attributedString
        }
    }
    
    @IBAction func btnNewRoot(_ sender: Any) {
        let index = Int(arc4random()) % self.keys.count
        self.key = SelectedKeys.getKeyByName(name: self.keys[index])
    }
    
    @IBAction func btnUpDown1(_ sender: Any) {
        self.direction = self.direction * -1
    }
    
    @IBAction func btnUpdpwn2(_ sender: Any) {
        self.direction = self.direction * -1
    }
    
    func makeInterval(btn : Int) {

        //let tonic = self.key.getRootNote() //
        var interval = 0
        var tonic = 0
        if (self.topic_selected >= 10 && self.topic_selected < 20) {
            self.tempo = 0.5
            if btn == 0 {
                tonic = self.tonics[self.top_tonic_index % self.tonics.count]
                self.top_tonic_index += 1
                if self.topic_selected == 10 {
                    interval = 7
                }
                if self.topic_selected == 11 {
                    interval = 5
                }
                if self.topic_selected == 12 {
                    interval = 3
                }
            }
            else {
                tonic = self.tonics[self.btm_tonic_index % self.tonics.count]
                self.btm_tonic_index += 1
                if self.topic_selected == 10 {
                    interval = 4
                }
                if self.topic_selected == 11 {
                    interval = 2
                }
                if self.topic_selected == 12 {
                    interval = 10
                }
            }
            let note1 = Note(noteValue: tonic)
            let note2 = Note(noteValue: tonic + interval)
            if self.direction > 0 {
                self.playInterval(noteSet1:[note1, note2], noteSet2: [], view: btn)
            }
            else {
                self.playInterval(noteSet1:[note2, note1], noteSet2: [], view: btn)
            }
        }
        
        // major, minor and sevenths
        if (self.topic_selected == 20) {
            self.tempo = 0.0
            if btn == 0 {
                tonic = self.tonics[self.top_tonic_index % self.tonics.count]
                self.top_tonic_index += 1
                let note1 = Note(noteValue: tonic)
                let note2 = Note(noteValue: tonic + 4)
                let note3 = Note(noteValue: tonic + 7)
                self.playInterval(noteSet1:[note1, note2, note3], noteSet2: [], view: btn)
            }
            else {
                tonic = self.tonics[self.btm_tonic_index % self.tonics.count]
                self.btm_tonic_index += 1
                let minor_root = tonic // - 3 //+2
                let note1 = Note(noteValue: minor_root)
                let note2 = Note(noteValue: minor_root + 4-1)
                let note3 = Note(noteValue: minor_root + 7)
                self.playInterval(noteSet1:[note1, note2, note3], noteSet2: [], view: btn)
            }
        }
        if (self.topic_selected == 21) {
            self.tempo = 0.0
            let root = tonic// + 7 - 12
            if btn == 0 {
                tonic = self.tonics[self.top_tonic_index % self.tonics.count]
                self.top_tonic_index += 1

                let note1 = Note(noteValue: root)
                let note2 = Note(noteValue: root + 4)
                let note3 = Note(noteValue: root + 7)
                let note4 = Note(noteValue: root + 10)
                self.playInterval(noteSet1:[note1, note2, note3, note4], noteSet2: [], view: btn)
            }
            else {
                tonic = self.tonics[self.btm_tonic_index % self.tonics.count]
                self.btm_tonic_index += 1
                let note1 = Note(noteValue: root)
                let note2 = Note(noteValue: root + 4-1)
                let note3 = Note(noteValue: root + 7)
                let note4 = Note(noteValue: root + 10)
                self.playInterval(noteSet1:[note1, note2, note3, note4], noteSet2: [], view: btn)
            }
        }
        
        // cadences
        if (self.topic_selected == 30 || self.topic_selected == 31) {
            self.tempo = 0.0
            if btn == 0 {
                tonic = self.tonics[self.top_tonic_index % self.tonics.count]
                self.top_tonic_index += 1

                //perfect cadence
                let root = tonic + 7 //- 12
                let note1 = Note(noteValue: root)
                let note2 = Note(noteValue: root + 4)
                let note3 = Note(noteValue: root + 7)
                
                let note4 = Note(noteValue: tonic)
                let note5 = Note(noteValue: tonic + 4)
                let note6 = Note(noteValue: tonic + 7)
                
                self.playInterval(noteSet1:[note1, note2, note3], noteSet2: [note4, note5, note6], view: btn)
            }
            else {
                tonic = self.tonics[self.btm_tonic_index % self.tonics.count]
                self.btm_tonic_index += 1

                //plagal IV -> I
                let root = tonic + 5
                let note1 = Note(noteValue: root)
                let note2 = Note(noteValue: root + 4)
                let note3 = Note(noteValue: root + 7)
                
                let note4 = Note(noteValue: tonic)
                let note5 = Note(noteValue: tonic + 4)
                let note6 = Note(noteValue: tonic + 7)
                
                self.playInterval(noteSet1:[note1, note2, note3], noteSet2: [note4, note5, note6], view: btn)
           }
        }
    }

    @IBAction func btnPlay5th(_ sender: Any) {
        self.makeInterval(btn: 0)
    }
    
    @IBAction func btn_3_tapped(_ sender: Any) {
        makeInterval(btn: 1)
    }
    
    func getStaff() -> Staff {
        //this treatment of staff keeps the sounds from instruments alive until the next 'play' when
        //the previous staff gets destroyed (deinit'd). Staff keeps a reference to notes that keeps them alive
        //(and therefore attached to the audio engine)
        if self.runningStaff != nil {
            self.runningStaff!.forceStop()
        }
        self.runningStaff = Staff()
        //let tempo = 0.5
        runningStaff!.setTempo(tempo: Double(self.tempo))
        return runningStaff!
    }
    
    func playInterval(noteSet1 : [Note], noteSet2 : [Note], view : Int) {
        let staff = self.getStaff()
        
        var index = Int(arc4random()) % self.instrument_names.count
        let inst_name = self.instrument_names[index]
        let instr = Instrument(midiPresetId: AvailableInstruments.getInstrumentId(name: inst_name))
        let voice : Voice = Voice(instr: instr, clef: CLEF_AUTO)
        //let voice1 : Voice = Voice(instr: inst2, clef: CLEF_AUTO)

        staff.addVoice(voice: voice)
        //staff.addVoice(voice: voice1)
        
        if self.tempo == 0 {
            var notes : [Int] = []
            for nt in noteSet1 {
                notes.append(nt.noteValue)
            }
            let chord1 = Chord(noteValues: notes)
            voice.add(object: chord1)
            
            if noteSet2.count > 0 {
                var notes : [Int] = []
                for nt in noteSet2 {
                    notes.append(nt.noteValue)
                }
                let chord2 = Chord(noteValues: notes)
                voice.add(object: chord2)
            }
            staff.setTempo(tempo: 1)
        }
        else {
            voice.add(object: noteSet1[0])
            voice.add(object: noteSet1[1])
            //voice1.add(object: Note(noteValue: 72 + 4))
            //voice1.add(object: Note(noteValue: 72 + 5))
        }
        voice.add(object: Rest())
        
        staff.play()
        if (view == 0) {
            self.uiViewStaff.setStaff(staff: staff, key: self.key)
            self.uiViewStaff.setNeedsDisplay()
            self.uiViewGraph1.setNotes(notes: [noteSet1[0].noteValue, noteSet1[1].noteValue])
            self.uiViewGraph1.setNeedsDisplay()
        }
        else {
            //self.StaffView_third.setStaff(staff: staff, key: SelectedKeys.getSelectedKey())
            self.StaffView_third.setStaff(staff: staff, key: self.key)
            self.StaffView_third.setNeedsDisplay()
            self.uiViewGraph2.setNotes(notes: [noteSet1[0].noteValue, noteSet1[1].noteValue])
            self.uiViewGraph2.setNeedsDisplay()
        }
    }
}

