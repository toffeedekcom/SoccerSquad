//
//  TableViewCell_accept.swift
//  ParseDemo
//
//  Created by toffee on 11/21/2559 BE.
//  Copyright © 2559 abearablecode. All rights reserved.
//

import UIKit
class TableViewCell_accept: UITableViewCell {
    
    
    @IBOutlet weak var imageTeam: UIImageView!
    @IBOutlet weak var nameTeam: UILabel!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var unaccept: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
          }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    
    
}
