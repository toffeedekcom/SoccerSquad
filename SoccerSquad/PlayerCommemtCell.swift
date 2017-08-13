//
//  PlayerCommemtCell.swift
//  Project2
//
//  Created by toffee on 6/26/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class PlayerCommemtCell: UITableViewCell {
    
    @IBOutlet weak var commentUser1: UILabel!
    @IBOutlet weak var imageUser1: UIImageView!
    @IBOutlet weak var viewUser1: UIView!
    
    
    
    @IBOutlet weak var commentUser2: UILabel!
    @IBOutlet weak var imageUser2: UIImageView!
    @IBOutlet weak var viewUser2: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
