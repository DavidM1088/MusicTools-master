import UIKit

class IdentifyIntervals: UIViewController {
    var selectedTonics = SelectedTonics.sharedInstance
    var selectedIntervals = SelectedIntervals.sharedInstance
    
    var lastTonic : Int?
    var lastInterval : Int?
    
    var runningStaff : Staff?

    @IBOutlet weak var sliderSpeed: UISlider!
    
    @IBOutlet weak var stepperOctave: UIStepper!

    @IBOutlet weak var btnRepeatClicked: UIButton!
    
    @IBOutlet weak var lblIntervalAnswer: UILabel!

    @IBOutlet weak var uiViewStaff: StaffView!
    
    @IBOutlet weak var segmentDirection: UISegmentedControl!
    
    @IBOutlet weak var labelOctave: UILabel!
    
    @IBOutlet weak var viewGraph: GraphView!
    
    @IBOutlet weak var TEST: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let btnSettings = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: Selector("settings"))
        let btnSettings = UIBarButtonItem(title: "Settings1", style: UIBarButtonItemStyle.plain, target: self, action: #selector(IdentifyIntervals.myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = btnSettings
        stepperOctave.value = 4
        self.setOctaveDesc()
        stepperOctave.minimumValue = 1
        stepperOctave.maximumValue = 7
        stepperOctave.stepValue = 1
        self.btnRepeatClicked.isEnabled = false
        self.lblIntervalAnswer.isHidden = true
        print("intervals view did load..")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setOctaveDesc() {
        self.labelOctave!.text = "\(Int(self.stepperOctave.value))"
    }
    
    @IBAction func stepperOctaveClicked(sender: AnyObject) {
        self.setOctaveDesc()
    }
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myRightSideBarButtonItemTapped")
        //performSegue(withIdentifier: "segueToSettings", sender: nil)
        performSegue(withIdentifier: "segue_test1", sender: nil)
         
    }
    //func settings() {
    //    performSegue(withIdentifier: "segueToSettings", sender: nil)
    //}
    
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
            let tempo = self.sliderSpeed.maximumValue - self.sliderSpeed.value
            runningStaff!.setTempo(tempo: Double(tempo))
        }
    }
    
    func playInterval(note1 : Note, note2 :Note) {
        let staff = self.getStaff()
        let inst1 = Instrument(midiPresetId: AvailableInstruments.getSelectedInstrument())
        let voice : Voice = Voice(instr: inst1, clef: CLEF_AUTO)
        staff.addVoice(voice: voice)
        let tempo = self.sliderSpeed.maximumValue - self.sliderSpeed.value
        print("tempo", tempo)
        if tempo == 0 {
            let chord = Chord(noteValues: [note1.noteValue, note2.noteValue])
            voice.add(object: chord)
            staff.setTempo(tempo: 1)
        }
        else {
            voice.add(object: note1)
            voice.add(object: note2)
        }
        voice.add(object: Rest())

        staff.play()
        self.uiViewStaff.setStaff(staff: staff, key: SelectedKeys.getSelectedKey())
        self.uiViewStaff.setNeedsDisplay()
        self.viewGraph.setNotes(notes: [note1.noteValue, note2.noteValue])
        self.viewGraph.setNeedsDisplay()
    }

    @IBAction func btnRepeatClicked(sender: AnyObject) {
        self.playInterval(note1: Note(noteValue: self.lastTonic!),
            note2 : Note(noteValue: self.lastTonic! + self.lastInterval!))
    }

    //MARK: Actions

    @IBAction func btnPlayClicked(_ sender: Any) {
        print("IN PLAY ")
        if self.selectedTonics.selectedCount() == 0 {
            AppDelegate.userMessage(message: "No interval roots selected")
            return
        }
        if self.selectedIntervals.selectedCount() == 0 {
            AppDelegate.userMessage(message: "No intervals selected")
            return
        }
        
        var totalCombinations = self.selectedTonics.selectedCount() * self.selectedIntervals.selectedCount()
        if self.segmentDirection.selectedSegmentIndex == 2 {
            totalCombinations *= 2
        }
        
        var tonic = 0
        var interval = 0
        while true {
            //get root
            while true {
                let index = Int(arc4random()) % self.selectedTonics.selected.count
                if self.selectedTonics.selected[index] {
                    tonic = self.selectedTonics.selectedNotes[index]
                    tonic += Int(self.stepperOctave.value - 4) * 12
                    break
                }
            }
            //get interval
            while true {
                let index = Int(arc4random()) % self.selectedIntervals.selected.count
                if self.selectedIntervals.selected[index] {
                    interval = self.selectedIntervals.intervals[index].interval
                    if self.segmentDirection.selectedSegmentIndex == 1 {
                        interval = 0 - interval
                    }
                    if self.segmentDirection.selectedSegmentIndex == 2 {
                        let rnd = Int(arc4random()) % 2
                        if rnd == 1 {
                            interval = 0 - interval
                        }
                    }
                    break
                }
            }
            if totalCombinations == 1 {
                break
            }
            else {
                //dont repeat the last one
                if tonic != self.lastTonic || interval != self.lastInterval {
                    break
                }
            }
        }
        
        let note1 = Note(noteValue: tonic)
        let note2 = Note(noteValue: tonic + interval)
        print(tonic, interval)
        self.playInterval(note1: Note(note: note1), note2: Note(note: note2))
        
        self.lblIntervalAnswer.text = self.selectedIntervals.intervals[abs(interval)].name
        self.lblIntervalAnswer.isHidden = false
        
        self.lastTonic = tonic
        self.lastInterval = interval
        self.btnRepeatClicked.isEnabled = true

    }
}
