
import UIKit

class MapCell: UITableViewCell {
    
    @IBOutlet private weak var mapNameLabel: UILabel!
    
    func setupCell(with object: String) {
        mapNameLabel.text = object
    }
}
