import UIKit

protocol YourCellDelegate1: class {
    //func didTapButton(_ sender: UIButton)
}

class ContentsListCell: UITableViewCell {

    @IBOutlet weak var btnGoThere: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    weak var delegate: YourCellDelegate1?
    
    //@IBAction func btn_nav_tapped(_ sender: Any) {
        //print("BTN CLICKED..")
        //delegate?.didTapButton(sender as! UIButton)
    //}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
        super.setSelected(selected, animated: animated)
        
    }
    
}
