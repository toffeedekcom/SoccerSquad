//
//  HistoryBookCell.swift
//  Project2
//
//  Created by toffee on 7/3/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class HistoryBookCell: UITableViewCell {
    
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var stopTime: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
