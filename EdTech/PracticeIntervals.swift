import UIKit

class PracticeIntervals: UIViewController /*, UIPickerViewDelegate, UIPickerViewDataSource*/ {
    //variables - sound, tempo->chord, tonic, octave, asc/desc
    var tempos = [0.5]
    var intervals = [1]
    var chords_relative = [[0, 4, 7], [0, 3, 7], [0, 4, 7, 10], [0, 4, 7, 11]]
    var cadences = [[7,0], [5,0]]
    var userSelectedInstrument = 0
    //var keys = ["Eb"]
    //var keys = ["D"]
    var keys = ["C"]
    var direction = [1]
    var content_label = ""
    
    var lastTonic : Int?
    var lastInterval : Int?
    var lastChord : [Int] = [0]
    var lastCadence : [Int] = [0]
    
    var progress = 0.0
    var level_tonic = [60]
    var adaptive_engine : AdaptiveEngine?
    private var level = 0
    private var playmode_repeat = false
    var show_notes = true
    var correct_answer = 0
    
    public var instrument_names : [String] = []
    public var topic_selected = 0
    
    @IBOutlet weak var progress_bar: UIProgressView!
    @IBOutlet weak var txtContext: UITextView!
    @IBOutlet weak var img_feedback: UIImageView!
    @IBOutlet weak var lblPrompt: UILabel!
    @IBOutlet weak var uiViewStaff: StaffView!
    //@IBOutlet weak var uiPickerInstrument: UIPickerView!
    @IBOutlet weak var btnPplay: UIButton!
    //ans buttons
    /*@IBOutlet weak var btn_3m: UIButton!
    @IBOutlet weak var btn_3: UIButton!
    @IBOutlet weak var btn_4: UIButton!
    @IBOutlet weak var btn_5: UIButton!
    @IBOutlet weak var btn_7: UIButton!*/
    
    //new ans buttons
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!

    var pickerData: [String] = [String]()
    var runningStaff : Staff?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    //Instruments picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        print("picker selected", row, component)
        self.userSelectedInstrument = row
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let btnSettings = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: Selector("settings"))
        let btnSettings = UIBarButtonItem(title: "Settings1", style: UIBarButtonItemStyle.plain, target: self, action: #selector(IdentifyIntervals.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = btnSettings
        
        //pickerData = ["Item 1"]
        let instruments = AvailableInstruments.getInstruments()
        for item in instruments {
            pickerData.append(item.name)
        }
        //self.uiPickerInstrument.delegate = self
        //self.uiPickerInstrument.dataSource = self
        //self.uiPickerInstrument.selectRow(6, inComponent: 0, animated: true)
        self.lblPrompt.text = ""
        
        let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 6.0)
        self.progress_bar.transform = transform
        self.progress_bar.progress = Float(self.progress)
        
        self.adaptive_engine = AdaptiveEngine()
        self.adaptive_engine?.readRules()
        self.setLevel()
        self.setMode(showQuestion: true, askNew: true)
        
        print ("practice topic", self.topic_selected)
        setContentType()
    }
    
    func setContentType() {
        if self.topic_selected == 0 {
            self.btnPplay.setTitle("Next interval", for: UIControlState.normal)
            self.btn1.setTitle("Min 3rd", for: UIControlState.normal)
            self.btn2.setTitle("Maj 3rd", for: UIControlState.normal)
            self.btn3.setTitle("Fourth", for: UIControlState.normal)
            self.btn4.setTitle("Fifth", for: UIControlState.normal)
            self.btn5.setTitle("Seventh", for: UIControlState.normal)
            self.content_label = "interval"
        }
        if self.topic_selected == 1 {
            self.btnPplay.setTitle("Next chord", for: UIControlState.normal)
            self.btn1.setTitle("Major", for: UIControlState.normal)
            self.btn2.setTitle("Minor", for: UIControlState.normal)
            self.btn3.setTitle("7th", for: UIControlState.normal)
            self.btn4.setTitle("Maj7th", for: UIControlState.normal)
            self.btn5.setTitle("", for: UIControlState.normal)
            self.content_label = "chord"
        }
        if self.topic_selected == 2 {
            self.btnPplay.setTitle("Next cadence", for: UIControlState.normal)
            self.btn1.setTitle("Perfect", for: UIControlState.normal)
            self.btn2.setTitle("Plagal", for: UIControlState.normal)
            self.btn3.setTitle("", for: UIControlState.normal)
            self.btn4.setTitle("", for: UIControlState.normal)
            self.btn5.setTitle("", for: UIControlState.normal)
            self.content_label = "cadence"

        }
    }
    
    func setMode(showQuestion : Bool, askNew : Bool) {
        if showQuestion {
            if askNew {
                self.playmode_repeat = false
                //self.btnPplay.setTitle("Play Next Interval", for: UIControlState.normal)
                self.setContentType()
            } else {
                self.playmode_repeat = true
                self.btnPplay.setTitle("Play It Again", for: UIControlState.normal)
            }
            self.btn1.isHidden = true
            self.btn2.isHidden = true
            self.btn3.isHidden = true
            self.btn4.isHidden = true
            self.btn5.isHidden = true
        }
        else {
            self.btn1.isHidden = false
            self.btn2.isHidden = false
            self.btn3.isHidden = false
            self.btn4.isHidden = false
            self.btn5.isHidden = false

            if self.topic_selected == 0 {
                self.lblPrompt.text = "What was the interval?"
            }
            if self.topic_selected == 1 {
                self.lblPrompt.text = "What was the chord?"
            }
            if self.topic_selected == 2 {
                self.lblPrompt.text = "What was the cadence?"
            }
        }
    }
    
    private func setLevel() {
        var html = ""
        html = """
        <html><body><font face="arial" color="black"><font size="4">
        """
        if self.level == 0 {
            html += "<b><font size='5'>Level One</b></br></br><font size='4'>"
            self.level_tonic = [60]
            self.tempos = [0.5]

            if self.topic_selected == 0 {
                html += "So now it's your turn to practice some intervals. Let's get started with some simple examples of fifths and thirds. Each interval will start at the same note and all will be ascending."
            }
            if self.topic_selected == 1 {
                html += "So now it's your turn to practice some chords. Let's get started with some simple triads and sevenths. Each cord will start at the same note and all will be treble clef."
            }
            if self.topic_selected == 2 {
                html += "So now it's your turn to practice some cadences. Let's get started with some perferct and plagal cadences. Each cadence will end at the same chord and all will be treble clef."
            }
            self.show_notes = true
        }

        if self.level == 1 {
            html += "<b><font size='5'>Level Two</b></br></br>"
            if self.topic_selected == 0 {
                html += "So lets try the same set of intervals but starting at different root notes and in different keys."
                self.level_tonic = [60, 64, 65, 69]
            }
            if self.topic_selected == 1 {
                html += "So now try the same chords but starting at different notes and in different keys."
                self.level_tonic = [60, 64, 65, 69]
            }
            if self.topic_selected == 2 {
                html += "So now try the same cadences but ending at different tonics and in different keys."
                self.level_tonic = [60, 64, 65, 69]
            }
            self.keys = ["C", "G", "E", "F", "Ab", "Bb", "Eb"]
        }
        
        if self.level == 2 {
            html += "<b><font size='5'>Level Ten</b></br></br>"
            self.show_notes = false
            self.keys = ["A", "E", "F", "Ab", "Eb"]
            self.level_tonic = [60, 69, 56, 50, 46, 72, 67, 58]

            if self.topic_selected == 0 {
                html += "This is the highest level. You will hear intervals in different registers, different keys, ascending and descending and in different tempos. In addition, the staff will not show the notes - so you have to rely on your own sense of pictch alone."
                self.tempos = [0.5, 0.5, 0.2, 0.3, 0.4, 0.2]
                self.direction = [1, -1]
            }
            if self.topic_selected == 1 {
                html += "This is the highest level. You will hear chords in different registers and different keys and differnt inversions. In addition, the staff will not show the notes - so you have to rely on your own sense of hearing alone."
            }
            if self.topic_selected == 2 {
                html += "This is the highest level. You will hear cadences in different registers and different keys and differnt inversions. In addition, the staff will not show the notes - so you have to rely on your own sense of hearing alone."
            }

        }
        if self.topic_selected == 0 {
            html += "</br></br>When an interval is played try to identify which one it was.</body>"
            
        }
        if self.topic_selected == 1 {
            html += "</br></br>When a chord is played try to identify which one it was.</body>"
            
        }
        if self.topic_selected == 2 {
            html += "</br></br>When a cadence is played try to identify which one it was.</body>"
            
        }
        let data = Data(html.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            self.txtContext.attributedText = attributedString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setOctaveDesc() {
        //self.labelOctave!.text = "\(Int(self.stepperOctave.value))"
    }

    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myRightSideBarButtonItemTapped")
        //performSegue(withIdentifier: "segueToSettings", sender: nil)
        performSegue(withIdentifier: "segue_test1", sender: nil)
    }

    func getStaff() -> Staff {
        //this treatment of staff keeps the sounds from instruments alive until the next 'play' when
        //the previous staff gets destroyed (deinit'd). Staff keeps a reference to notes that keeps them alive
        //(and therefore attached to the audio engine)
        if self.runningStaff != nil {
            self.runningStaff!.forceStop()
        }
        self.runningStaff = Staff()
        setTempo()
        return runningStaff!
    }
    
    func setTempo() {
        if runningStaff != nil {
            var index = Int(arc4random()) % self.tempos.count
            runningStaff!.setTempo(tempo: Double(self.tempos[index]))
        }
    }
    
    func playInterval(note1 : Note, note2 :Note, chord1: Chord, chord2: Chord) {
        
        let staff = self.getStaff()
        var index = Int(arc4random()) % self.instrument_names.count
        let inst_name = self.instrument_names[index]
        let instr = Instrument(midiPresetId: AvailableInstruments.getInstrumentId(name: inst_name))
        let voice : Voice = Voice(instr: instr, clef: CLEF_AUTO)
        staff.addVoice(voice: voice)
        if self.topic_selected == 0 {
            index = Int(arc4random()) % self.direction.count
            let dir = self.direction[index]
            if dir > 0 {
                voice.add(object: note1)
                voice.add(object: note2)
            }
            else {
                voice.add(object: note2)
                voice.add(object: note1)
            }
            voice.add(object: Rest())
        }
        if self.topic_selected == 1 {
            voice.add(object: chord1)
        }
        if self.topic_selected == 2 {
            voice.add(object: chord1)
            voice.add(object: chord2)
        }
        staff.play()
        index = Int(arc4random()) % self.keys.count
        self.uiViewStaff.setStaff(staff: staff, key: SelectedKeys.getKeyByName(name: self.keys[index]))
        self.uiViewStaff.show_notes = self.show_notes
        self.uiViewStaff.setNeedsDisplay()
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        if self.topic_selected == 0 {
            var tonic = 0
            var interval = 0
            if self.playmode_repeat {
                tonic = self.lastTonic!
                interval = self.lastInterval!
            }
            else {
                while true {
                    var index = Int(arc4random()) % self.level_tonic.count
                    tonic = self.level_tonic[index]
                    index = Int(arc4random()) % self.intervals.count
                    self.correct_answer = index
                    interval = self.intervals[index]
                    if tonic != self.lastTonic || interval != self.lastInterval {
                        break
                    }
                }
            }
            let note1 = Note(noteValue: tonic)
            let note2 = Note(noteValue: tonic + interval)
            let chord = Chord(noteValues: [])
            print ("\n================================> INTERVAL:", interval)

            self.playInterval(note1: Note(note: note1), note2: Note(note: note2), chord1: chord, chord2: chord)
            
            self.lastTonic = tonic
            self.lastInterval = interval
        }
        if self.topic_selected == 1 {
            var tonic = 0
            var chord_relative = [0]

            if self.playmode_repeat {
                tonic = self.lastTonic!
                chord_relative = self.lastChord
            }
            else {
                while true {
                    var index = Int(arc4random()) % self.level_tonic.count
                    tonic = self.level_tonic[index]
                    index = Int(arc4random()) % self.chords_relative.count
                    self.correct_answer = index
                    chord_relative = self.chords_relative[index]
                    //if tonic != self.lastTonic {
                        break
                    //}
                }
            }
            let note = Note(noteValue: 0)
            var chord : [Int] = []
            for x in chord_relative {
                chord.append(x + tonic)
            }
            let chord1 = Chord(noteValues: chord)
            print ("\n================================> CHORD:", chord_relative)

            self.playInterval(note1: note, note2: note, chord1: chord1, chord2: Chord(noteValues: []))
            
            self.lastTonic = tonic
            self.lastChord = chord_relative
        }
        
        if self.topic_selected == 2 {
            var tonic = 0
            var cadence = [0]
            
            if self.playmode_repeat {
                tonic = self.lastTonic!
                cadence = self.lastCadence
            }
            else {
                while true {
                    var index = Int(arc4random()) % self.level_tonic.count
                    tonic = self.level_tonic[index]
                    index = Int(arc4random()) % self.cadences.count
                    self.correct_answer = index
                    cadence = self.cadences[index]
                    //if tonic != self.lastTonic {
                    break
                    //}
                }
            }
            let note = Note(noteValue: 0)
            var chord1 : [Int] = []
            var chord2 : [Int] = []
            for x in [0, 4, 7] {
                chord1.append(x + tonic + cadence[0] )
                chord2.append(x + tonic + cadence[1] )
            }
            print ("\n================================> CADENCE Perfect?:", cadence[0] == 7)

            self.playInterval(note1: note, note2: note, chord1: Chord(noteValues: chord1), chord2: Chord(noteValues: chord2))
            
            self.lastTonic = tonic
            self.lastCadence = cadence
        }

        self.setMode(showQuestion: false, askNew: false)
    }
    
    func adapt() {
        self.progress = 0.0;
        self.lblPrompt.text = "Lets move to the next level"
        let alert = UIAlertController(title: "Next Level", message: "You've got it! Lets go to the next level", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
        self.level += 1
        self.setLevel()
    }
    
    func isCorrect(btn: Int) {
        if (btn-1 == self.correct_answer) {
            self.lblPrompt.text = "Nice job! Lets try another .."
            self.img_feedback.image = UIImage(named:"emote_smile")
            if self.progress < 1 {
                self.progress = self.progress + 0.2
            }
            self.setMode(showQuestion: true, askNew: true)
            if (self.progress >= 1) {
                adapt()
            }
        }
        else {
            self.lblPrompt.text = "Not that one. Lets try again ..."
            self.img_feedback.image = UIImage(named:"emote_sad")
            self.setMode(showQuestion: true, askNew: false)
            if self.progress > 0 {
                self.progress = self.progress - 0.2
            }
        }
        print ("prg:", self.progress)
        self.progress_bar.progress = Float(self.progress)
        self.img_feedback.setNeedsDisplay()
    }

    @IBAction func btn1_tapped(_ sender: Any) {
        self.isCorrect(btn: 1)
    }
    @IBAction func btn2_tapped(_ sender: Any) {
        self.isCorrect(btn: 2)
    }
    @IBAction func btn3_tapped(_ sender: Any) {
        self.isCorrect(btn: 3)
    }
    @IBAction func btn4_tapped(_ sender: Any) {
        self.isCorrect(btn: 4)
    }
    @IBAction func btn5_tapped(_ sender: Any) {
        self.isCorrect(btn: 5)
    }
}
