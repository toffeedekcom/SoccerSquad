//
//  BookCell.swift
//  Project2
//
//  Created by toffee on 7/2/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var stopTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
