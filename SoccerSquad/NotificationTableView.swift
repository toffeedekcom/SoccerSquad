//
//  NotificationTableView.swift
//  Project2
//
//  Created by CSmacmini on 6/30/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class NotificationTableView: UITableViewController {
    
    var uid = userId
    
    var data_uid = ""
    var data_fid = ""
    var data_mnf_id = ""

    
    
    
    
    var get_username = ""
    var get_name_field = ""
    var get_name_sub = ""
    var get_booktime = ""
    var get_booktime2 = ""
    var get_price = ""
    var get_status = ""
    var get_date = ""
    var get_image = ""
    
    
    var arrUSERNAME = [String]()
    var arrNAMEFIELD = [String]()
    var arrNAMESUB = [String]()
    var arrBOOKTIME = [String]()
    var arrPRICE = [String]()
    var arrSTATUS = [String]()
    var arrDATE = [String]()
    var arrIMAGE = [String]()
    var arrBOKKTIME2 = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.clearColor()
        tableView.allowsSelection = false
        selectField()

    }
    
    override func viewDidAppear(animated: Bool) {
        tabBarController?.tabBar.items?[4].badgeValue = nil
    }
    
    func selectField() {
        let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectNotification.php"
        var parameter:[String:String] = ["uid": uid]
        
        Alamofire.request(.GET,url ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Not found data")
                }else {
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.get_image = (value["uimage"] as? String)!
                        self.get_username = (value["uname"] as? String)!
                        self.get_name_field = (value["fname"] as? String)!
                        self.get_name_sub = (value["mnf_type"] as? String)!
                        self.get_booktime = (value["bstartime"] as? String)!
                        self.get_booktime2 = (value["bstoptime"] as? String)!
                        self.get_price = (value["bprice"] as? String)!
                        self.get_date = (value["bdate"] as? String)!
                        self.get_status = (value["bstatus"] as? String)!
                        
                        
                        self.arrIMAGE.append(self.get_image)
                        self.arrUSERNAME.append(self.get_username)
                        self.arrNAMEFIELD.append(self.get_name_field)
                        self.arrNAMESUB.append(self.get_name_sub)
                        self.arrBOOKTIME.append(self.get_booktime)
                        self.arrBOKKTIME2.append(self.get_booktime2)
                        self.arrPRICE.append(self.get_price)
                        self.arrDATE.append(self.get_date)
                        self.arrSTATUS.append(self.get_status)
                    }
                    self.tableView.reloadData()
                    

                }
                
        }
        
    }
    
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            completion(image_Field)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 120
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrUSERNAME.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! notificationCell
        
        myCell.name.text = arrUSERNAME[indexPath.row]
        myCell.namefield.text = arrNAMEFIELD[indexPath.row]
        myCell.name_subfield.text = arrNAMESUB[indexPath.row]
        myCell.bookingtime.text = arrBOOKTIME[indexPath.row]+" - "+arrBOKKTIME2[indexPath.row]
        myCell.priceLabel.text = arrPRICE[indexPath.row]+" baht"
        myCell.dateLabel.text = arrDATE[indexPath.row]
        myCell.statusLabel.text = arrSTATUS[indexPath.row]
        
        if arrSTATUS[indexPath.row] == "Waiting" {
            myCell.statusWaitting()
        }else if arrSTATUS[indexPath.row] == "Success" {
            myCell.statusSuccess()
        }else {
            myCell.statusConfirm()
        }
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + arrIMAGE[indexPath.row]
        
        if urlImage.isEmpty {
            myCell.ImageView.image = UIImage(named: "picture")
        }else {
            
            downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                
                if image == nil {
                    myCell.ImageView.image = UIImage(named: "picture")
                    
                }else {
                    
                    myCell.ImageView.image = image
                    myCell.ImageView.contentMode = .ScaleAspectFill
                    myCell.ImageView.layer.borderWidth = 1.0
                    myCell.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    myCell.ImageView.layer.masksToBounds = false
                    myCell.ImageView.layer.cornerRadius = myCell.ImageView.frame.height/2
                    myCell.ImageView.clipsToBounds = true
                    
                }
            }
            
        }
        
        return myCell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    
}

class notificationCell: UITableViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var namefield: UILabel!
    @IBOutlet weak var name_subfield: UILabel!
    @IBOutlet weak var bookingtime: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func statusSuccess() {
        statusLabel.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        statusLabel.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        statusLabel.layer.borderWidth = 1.0
        statusLabel.layer.cornerRadius = 10
    }
    
    func statusWaitting() {
        statusLabel.layer.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
        statusLabel.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
        statusLabel.layer.borderWidth = 1.0
        statusLabel.layer.cornerRadius = 10
    }
    
    func statusConfirm() {
        statusLabel.layer.backgroundColor = UIColor(red:0.04, green:0.77, blue:0.55, alpha:1.0).CGColor
        statusLabel.layer.borderColor = UIColor(red:0.04, green:0.77, blue:0.55, alpha:1.0).CGColor
        statusLabel.layer.borderWidth = 1.0
        statusLabel.layer.cornerRadius = 10
        
    }

    
}
