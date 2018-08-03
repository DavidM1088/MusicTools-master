import UIKit
// delegates to send data to next view https://medium.com/@jacqschweiger/how-to-segue-programmatically-using-delegates-in-swift-e333a9800f5

class ContentsController: UITableViewController, YourCellDelegate1 {
    
    //private var topics = [String]()
    private var topicsList: [(name: String, level: Int, type: Int, topic_id: Int)] = []
    private var selected_topic: Int = 0
    private var selected_type: Int = 0
    //MARK: - UIViewController
    static public let TYPE_CONTENT = 0
    static public let TYPE_EXAMPLES = 1
    static public let TYPE_PRACTICE = 2
    static public let INTERVALS = 0
    static public let CHORDS = 1
    static public let CADENCES = 2

    override func viewDidLoad() {

        topicsList.append(("Intervals", 0, ContentsController.TYPE_CONTENT, 0))
        topicsList.append(("Fifths and Thirds", 1, ContentsController.TYPE_CONTENT, 10))
        topicsList.append(("Fourths and Seconds", 1, ContentsController.TYPE_CONTENT,  11))
        topicsList.append(("Minor Thirds and Sevenths", 1, ContentsController.TYPE_CONTENT, 12))
        topicsList.append(("Examples", 1, ContentsController.TYPE_EXAMPLES, ContentsController.INTERVALS))
        topicsList.append(("Practice", 1, ContentsController.TYPE_PRACTICE, ContentsController.INTERVALS))
        
        topicsList.append(("Chords", 0, ContentsController.TYPE_CONTENT, 0))
        topicsList.append(("Major and Minor", 1, ContentsController.TYPE_CONTENT, 20))
        //topicsList.append(("Sevenths", 1, ContentsController.TYPE_CONTENT, 21))
        topicsList.append(("Examples", 1, ContentsController.TYPE_EXAMPLES, ContentsController.CHORDS))
        topicsList.append(("Practice", 1, ContentsController.TYPE_PRACTICE, ContentsController.CHORDS))

        topicsList.append(("Cadences", 0, ContentsController.TYPE_CONTENT, 0))
        topicsList.append(("Perfect and Plagal", 1, ContentsController.TYPE_CONTENT, 30))
        topicsList.append(("Examples", 1, ContentsController.TYPE_EXAMPLES, ContentsController.CADENCES))
        topicsList.append(("Practice", 1, ContentsController.TYPE_PRACTICE, ContentsController.CADENCES))

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ContentsListCell
        //cell.lblTitle.text = topics[indexPath.row]
        cell.lblTitle.text = topicsList[indexPath.row].name
        self.selected_topic = topicsList[indexPath.row].topic_id
        self.selected_type = topicsList[indexPath.row].type
        if (topicsList[indexPath.row].level == 1) {
            cell.lblTitle.text = "\t"+cell.lblTitle.text!
        }
        if self.selected_type == ContentsController.TYPE_CONTENT && topicsList[indexPath.row].level > 0 {
            cell.btnGoThere.setBackgroundImage(UIImage(named: "page_content"), for: .normal)
        }
        if self.selected_type == ContentsController.TYPE_EXAMPLES {
            cell.btnGoThere.setBackgroundImage(UIImage(named: "guitar"), for: .normal)
        }
        if self.selected_type == ContentsController.TYPE_PRACTICE {
            cell.btnGoThere.setBackgroundImage(UIImage(named: "icon_interval"), for: .normal)
        }
        cell.btnGoThere.setTitle("",for: .normal)
        if (topicsList[indexPath.row].level == 0 ) {
            cell.lblTitle.textColor = UIColor.blue
        }
        else {
            cell.lblTitle.font = cell.lblTitle.font.withSize(15)
        }
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is IntervalsContent {
            let vc = segue.destination as? IntervalsContent
            vc?.topic_selected = self.selected_topic
            vc?.keys = ["C", "D", "A", "F", "Bb", "Eb"]
            //vc?.keys = ["D"]
            vc?.instrument_names = [/*"Cello",*/ "Synth Strings", "Choir", "Flute" /*, "Stereo Strings" slow*/]
        }
        
        if segue.destination is ExamplesController {
            //let vc = segue.destination as? ExamplesController
            //vc?.tempos = [0.5] //
            //vc?.intervals = [4, 5, 7, 10, 3]
            //vc?.selectedInstrument = 8 //cello 5=electirc guitar
        }

        if segue.destination is PracticeIntervals {
            let vc = segue.destination as? PracticeIntervals
            vc?.tempos = [0.5]
            vc?.intervals = [3, 4, 5, 7, 10]
            vc?.topic_selected = self.selected_topic
            vc?.instrument_names = ["Synth Strings", "Choir", "Flute"]
        }
    }
    
    @IBAction func btnGoTapped1(_ sender: UIButton) {

        if let indexPath = getCurrentCellIndexPath(sender) {
            self.selected_topic = topicsList[indexPath.row].topic_id
            if topicsList[indexPath.row].type == ContentsController.TYPE_CONTENT {
                self.performSegue(withIdentifier: "learnIntervals1", sender: nil)
            }
            if topicsList[indexPath.row].type == ContentsController.TYPE_EXAMPLES {
                self.performSegue(withIdentifier: "exampleIntervals", sender: nil)
            }
            if topicsList[indexPath.row].type == ContentsController.TYPE_PRACTICE {
                self.performSegue(withIdentifier: "practiceIntervals1", sender: nil)
            }           
        }
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
}
