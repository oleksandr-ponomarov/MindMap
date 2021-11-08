//
//  MapCell.swift
//  MindMap
//
//  Created by Aleksandr on 09.11.2021.
//

import UIKit

class MapCell: UITableViewCell {
    
    @IBOutlet private weak var mapNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(with object: String) {
        mapNameLabel.text = object
    }
    
}
