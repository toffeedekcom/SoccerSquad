//
//  OwnerCommentCell.swift
//  Project2
//
//  Created by toffee on 7/5/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class OwnerCommentCell: UITableViewCell {
    
   
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var messengerYou: UILabel!
    @IBOutlet weak var viewUser: UIView!
    
    
   
    @IBOutlet weak var imageOwner: UIImageView!
    @IBOutlet weak var messengerMe: UILabel!
    
    @IBOutlet weak var viewOwner: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
