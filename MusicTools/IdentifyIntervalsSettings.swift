import UIKit

class IdentifyIntervalsSettings: UITableViewController {
    var items: [String] = ["Intervals", "Interval Roots", "Instruments", "Keys"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("intervals settings loaded")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellType : String?
        switch (indexPath.row) {
            case 0: cellType = "intervalsSettingsRow"
            case 1: cellType = "rootsSettingsRow"
            case 2: cellType = "instrumentsSettingsRow"
            case 3: cellType = "keysSettingsRow" 
            default : cellType = nil
        }
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellType!) as! UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let object = items[indexPath.row]
        cell.textLabel!.text = object.description
        return cell
    }
    
}
