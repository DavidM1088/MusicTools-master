import UIKit

class SelectKeys: UITableViewController {
    private var keys = SelectedKeys.sharedInstance
    //private var staff : Staff?
    private var lastSelectedPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("key settings loaded")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keys.keys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "key") as! UITableViewCell
        cell.textLabel?.text = self.keys.keys[indexPath.row].getName()
        
        if indexPath.row == self.keys.selected {
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
        self.keys.selected = indexPath.row
        let cell : UITableViewCell = self.tableView.cellForRow(at: indexPath as IndexPath)!
        cell.accessoryType = .checkmark
    }
}
