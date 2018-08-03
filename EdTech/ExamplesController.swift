import UIKit
// delegates to send data to next view https://medium.com/@jacqschweiger/how-to-segue-programmatically-using-delegates-in-swift-e333a9800f5

class ExamplesController: UITableViewController, YourCellDelegate2 {
    
    private var topicsList: [(interval: String, example: String, url: String, type: Int)] = []
    
    @IBAction func btnGoTapped1(_ sender: UIButton) {

        if let indexPath = getCurrentCellIndexPath(sender) {
            //let item = topics[indexPath.row]
            //print(item)
            if topicsList[indexPath.row].type == 0 {
                let url  = topicsList[indexPath.row].url
                UIApplication.shared.openURL(NSURL(string: url)! as URL)
            }
        }
    }
    //MARK: - UIViewController
    override func viewDidLoad() {
        //topics = ["Intervals", "\tFifths and Thirds", "\tFourths and Seconds", "\tMinor Intervals", "\t", "\t*Practice", "Chords","\t","\tMinor Triads","Progressions", //"\tBlues Progression","\tPerfect Cadences",]
        topicsList.append(("Perfect Fifth", "2001 Space Odyssey", "https://www.youtube.com/watch?v=QwxYiVXYyVs&t=22", 0))
        topicsList.append(("Perfect Fifth", "Twinkle, Twinkle Little Star", "https://www.youtube.com/watch?v=yCjJyiqpAuU&feature=youtu.be&t=18", 0))
        topicsList.append(("Major Third", "Kumbaya", "https://www.youtube.com/watch?v=p3MiD_U4CHQ", 0))
        topicsList.append(("Fourth", "Here Comes The Bride", "https://www.youtube.com/watch?v=lgh9XTkQTDI&feature=youtu.be&t=7", 0))
        topicsList.append(("Minor Third", "Greensleaves", "https://www.youtube.com/watch?v=P5ItNxpwChE&feature=youtu.be", 0))
        tableView.reloadData()
    }
    //MARK: - UITableViewDataSource


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ExampleListCell
        //cell.lblTitle.text = topics[indexPath.row]
        cell.lblDesc1.text = topicsList[indexPath.row].interval
        cell.lblDesc2.text = topicsList[indexPath.row].example
        cell.lblDesc1.font = cell.lblDesc1.font.withSize(14)
        cell.lblDesc2.font = cell.lblDesc2.font.withSize(14)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PracticeIntervals {
            let vc = segue.destination as? PracticeIntervals
            //vc?.tempo = [0.5
            vc?.intervals = [0, 4, 7, 12]
        }
    }

    func didTapButton(_ sender: UIButton) {
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
}
