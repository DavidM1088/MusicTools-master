import UIKit

class SelectInstrument: UITableViewController {
    private var instruments = AvailableInstruments.sharedInstance
    private var staff : Staff?
    private var lastSelectedPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("instr settings loaded")
    }
    
    func getStaff() -> Staff {
        if self.staff != nil {
            self.staff!.forceStop()
        }
        self.staff = Staff()
        staff?.setTempo(tempo: 1)
        return staff!
    }
    
    @IBAction func btnPlayClicked(sender: UIButton) {
        let id :String = sender.title(for: UIControlState.selected)!
        let midiId :Int = Int(id)!
        let inst1 = Instrument(midiPresetId: midiId)
        let voice1 : Voice = Voice(instr: inst1, clef: CLEF_AUTO)
        let staff = getStaff()
        staff.addVoice(voice: voice1)
        voice1.add(object: Note(noteValue: 64))
        voice1.add(object: Rest())
        staff.play()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instruments.instruments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "instrument") as! UITableViewCell
        cell.textLabel?.text = self.instruments.instruments[indexPath.row].name

        //store the midi id in the button title so we can retrieve the midi id on button push
        let btnPlay : UIButton = cell.viewWithTag(10) as! UIButton!
        let midiId = "\(self.instruments.instruments[indexPath.row].id)"
        btnPlay.setTitle(midiId, for: UIControlState.selected)

        if indexPath.row == self.instruments.selected {
            cell.accessoryType = .checkmark
            self.lastSelectedPath = indexPath
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.lastSelectedPath != nil {
            if self.tableView.cellForRow(at: self.lastSelectedPath! as IndexPath) == nil {
            }
            else {
                let lastCell : UITableViewCell = self.tableView.cellForRow(at: self.lastSelectedPath! as IndexPath)!
                lastCell.accessoryType = .none
            }
        }
        self.lastSelectedPath = indexPath
        self.instruments.selected = indexPath.row
        let cell : UITableViewCell = self.tableView.cellForRow(at: indexPath as IndexPath)!
        cell.accessoryType = .checkmark
        //cell.n
    }
}
