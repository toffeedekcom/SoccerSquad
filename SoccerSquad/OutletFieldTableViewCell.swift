//
//  OutletFieldTableViewCell.swift
//  Project2
//
//  Created by toffee on 6/19/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class OutletFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewField: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var statusFieldimge: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
//    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var ImageOwner: UIImageView!
    
    @IBOutlet weak var PostDate: UILabel!
    @IBOutlet weak var NameOwner: UILabel!
    func customStatusOpen() {
        
        statusLabel.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        statusLabel.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        statusLabel.layer.borderWidth = 1.0
        statusLabel.layer.cornerRadius = 10
    }
    
    func customStatusClose() {
        statusLabel.layer.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
        statusLabel.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
        statusLabel.layer.borderWidth = 1.0
        statusLabel.layer.cornerRadius = 10
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
