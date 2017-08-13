//
//  EditLocationTableViewCell.swift
//  Project2
//
//  Created by toffee on 6/24/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class EditLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageField: UIImageView!
    
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
