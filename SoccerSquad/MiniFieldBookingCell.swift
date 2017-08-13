//
//  MiniFieldBookingCell.swift
//  Project2
//
//  Created by toffee on 7/1/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class MiniFieldBookingCell: UITableViewCell {
    
    
    @IBOutlet weak var imageMiniField: UIImageView!
    @IBOutlet weak var nameMiniField: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
