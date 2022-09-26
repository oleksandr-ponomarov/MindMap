
import UIKit

final class MapCell: UITableViewCell {
    
    @IBOutlet private weak var mapNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func setupCell(title: String?) {
        mapNameLabel.text = title
    }
}
