//
//  SelectTeamCell.swift
//  Project2
//
//  Created by toffee on 6/22/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class SelectTeamCell: UITableViewCell {
    
    
    
    @IBOutlet weak var imageTeam: UIImageView!
    @IBOutlet weak var nameTeam: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
