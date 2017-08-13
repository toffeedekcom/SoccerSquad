//
//  ShowEventAllCell.swift
//  Project2
//
//  Created by toffee on 6/23/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class ShowEventAllCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var nameEvent: UILabel!
    @IBOutlet weak var detail: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
