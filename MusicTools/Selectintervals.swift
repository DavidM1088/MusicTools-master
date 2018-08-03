import UIKit

class SelectIntervals: UITableViewController {
    private var selectedIntervals = SelectedIntervals.sharedInstance
    private var staff : Staff?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("interval settings loaded")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedIntervals.intervals.count
    }
    
    func getStaff() -> Staff {
        if self.staff != nil {
            self.staff!.forceStop()
        }
        self.staff = Staff()
        staff?.setTempo(tempo: 1)
        return staff!
    }
    
    @IBAction func btnPlayClciked(sender: UIButton) {
        let id :String = sender.title(for: UIControlState.selected)!
        let intervalRange :Int = Int(id)!
        let instr = Instrument(midiPresetId: AvailableInstruments.getSelectedInstrument())
        let voice1 : Voice = Voice(instr: instr, clef: CLEF_AUTO)
        let staff = getStaff()
        staff.addVoice(voice: voice1)
        let root = 64
        voice1.add(object: Note(noteValue: root))
        voice1.add(object: Note(noteValue: root + intervalRange))
        voice1.add(object: Rest())
        staff.play()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cellTypeId") as! UITableViewCell
        cell.textLabel?.text = self.selectedIntervals.intervals[indexPath.row].name
        if self.selectedIntervals.selected[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        let btnPlay : UIButton = cell.viewWithTag(10) as! UIButton!
        let intervalRange = "\(self.selectedIntervals.intervals[indexPath.row].interval)"
        btnPlay.setTitle(intervalRange, for: UIControlState.selected)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : UITableViewCell = self.tableView.cellForRow(at: indexPath as IndexPath)!
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            self.selectedIntervals.selected[indexPath.row] = true
        }
        else {
            cell.accessoryType = .none
            self.selectedIntervals.selected[indexPath.row] = false
        }
    }
}
