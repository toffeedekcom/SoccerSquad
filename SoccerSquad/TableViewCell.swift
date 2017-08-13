//
//  TableViewCell.swift
//  ParseDemo
//
//  Created by toffee on 11/15/2559 BE.
//  Copyright © 2559 abearablecode. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var showlable: UILabel!
    @IBOutlet weak var invlit: UIButton!
   
    override func awakeFromNib() {
    super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
