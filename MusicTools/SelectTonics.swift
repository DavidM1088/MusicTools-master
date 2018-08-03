import UIKit

class SelectTonics: UITableViewController {
    var selectedTonics = SelectedTonics.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("keys settings loaded")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedTonics.selectedNotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "keyId") as! UITableViewCell
        cell.textLabel?.text = self.selectedTonics.selectedNoteNames[indexPath.row]
        if self.selectedTonics.selected[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("keyselected..\(self.items[indexPath.row]) ")
        let cell : UITableViewCell = self.tableView.cellForRow(at: indexPath as IndexPath)!
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            self.selectedTonics.selected[indexPath.row] = true
        }
        else {
            cell.accessoryType = .none
            self.selectedTonics.selected[indexPath.row] = false
        }

    }
}
