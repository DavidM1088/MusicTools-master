import UIKit

protocol YourCellDelegate2: class {
    func didTapButton(_ sender: UIButton)
}

class ExampleListCell: UITableViewCell {
    
    @IBOutlet weak var lblDesc1: UILabel!
    @IBOutlet weak var lblDesc2: UILabel!
    weak var delegate: YourCellDelegate2?
    
    @IBAction func btn_nav_tapped(_ sender: Any) {
        //print("BTN CLICKED..")
        delegate?.didTapButton(sender as! UIButton)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
        super.setSelected(selected, animated: animated)
        
    }
    
}
