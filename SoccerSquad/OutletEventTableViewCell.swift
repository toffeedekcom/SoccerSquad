//
//  OutletEventTableViewCell.swift
//  Project2
//
//  Created by CSmacmini on 6/23/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class OutletEventTableViewCell: UITableViewCell {

    @IBOutlet weak var EventimageView: UIImageView!
    @IBOutlet weak var EventnameLabel: UILabel!
    @IBOutlet weak var EventdataLabel: UILabel!
    @IBOutlet weak var EventplaceLabel: UILabel!
    @IBOutlet weak var datetime: UILabel!
    @IBOutlet weak var EventTimeClose: UILabel!
    @IBOutlet weak var dateopen: UILabel!
    @IBOutlet weak var dateclose: UILabel!
    
    func customDateUI() {
        EventdataLabel.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        EventdataLabel.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        EventdataLabel.layer.borderWidth = 1.0
        EventdataLabel.layer.cornerRadius = 15
    }
}
