//
//  myTeamCell.swift
//  ParseDemo
//
//  Created by toffee on 5/29/2560 BE.
//  Copyright © 2560 abearablecode. All rights reserved.
//

import UIKit

class myTeamCell: UITableViewCell {
    
    
    
   
    
    @IBOutlet weak var showImage: UIImageView!
   
    
    @IBOutlet weak var nameTeam: UILabel!
    
   
  
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        showImage.contentMode = .ScaleAspectFit
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
