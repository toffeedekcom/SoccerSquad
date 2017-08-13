//
//  DetailView.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/12/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
class DetailView: UITableViewController {

    var uname = ""
    var uimage = ""
    var ugender = ""
    var uemail = ""
    var utel = ""
    
    var bookid = ""
    var bstatus = ""
    var bpirce = ""
    var bpledge = ""
    var pledgeImage = ""
    
    var dateP = ""
    var imageP = ""
    
    var arrDATE = [String]()
    var arrIMAGE = [String]()
    
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var tel: UILabel!
    
    @IBOutlet weak var imagePledge: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var Pledge: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.refreshControl?.addTarget(self, action: #selector(DetailView.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        getUser()
        selectPledge()
        tableView.reloadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        getUser()
        selectPledge()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getUser() {
        
        self.name.text = self.uname
        self.email.text = self.uemail
        self.tel.text = self.utel
        self.gender.text = self.ugender
        self.price.text = self.bpirce
        self.Pledge.text = self.bpledge
        self.status.text = self.bstatus
        
        if self.status.text == "Waiting" {
            status.layer.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
            status.layer.borderColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0).CGColor
            status.layer.borderWidth = 1.0
            status.layer.cornerRadius = 10
        }else if self.status.text == "Success" {
            status.layer.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
            status.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
            status.layer.borderWidth = 1.0
            status.layer.cornerRadius = 10
        }else if self.status.text == "Confirm" {
            status.layer.backgroundColor = UIColor(red:0.04, green:0.77, blue:0.55, alpha:1.0).CGColor
            status.layer.borderColor = UIColor(red:0.04, green:0.77, blue:0.55, alpha:1.0).CGColor
            status.layer.borderWidth = 1.0
            status.layer.cornerRadius = 10
        }
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/"+self.uimage
        
        if urlImage.isEmpty {
            ImageView.image = UIImage(named: "picture")
        }else {
            
            downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                
                if image == nil {
                    self.ImageView.image = UIImage(named: "picture")
                    
                }else {
                    
                    self.ImageView.image = image
                    self.ImageView.contentMode = .ScaleAspectFill
                    self.ImageView.layer.borderWidth = 1.0
                    self.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    self.ImageView.layer.masksToBounds = false
                    self.ImageView.layer.cornerRadius = self.ImageView.frame.height/2
                    self.ImageView.clipsToBounds = true
                    
                }
            }
            
        }
    }
    
    func selectPledge() {
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selecPledge.php"
        print(bookid)
        var parameter:[String:String] = ["bookid": bookid]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    self.MyAlerts("Deposit is not transferable!")
                }else {
                    
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.dateP = (value["pledgedate"] as? String)!
                        self.imageP = (value["pledgeimage"] as? String)!
                        
                        self.arrDATE.append(self.dateP)
                        self.arrIMAGE.append(self.imageP)
                    }
                }
                self.date.text = self.dateP
                
        }
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/booking/imageslip/"+self.imageP
        
        if urlImage.isEmpty {
            self.imagePledge.image = UIImage(named: "picture")
        }else {
            
            downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                
                if image == nil {
                    self.imagePledge.image = UIImage(named: "picture")
                    
                }else {
                    
                    self.imagePledge.image = image
                    self.imagePledge.contentMode = .ScaleAspectFill
                    self.imagePledge.layer.borderWidth = 1.0
                    self.imagePledge.layer.borderColor = UIColor.whiteColor().CGColor;
                    self.imagePledge.layer.masksToBounds = false
                    self.imagePledge.layer.cornerRadius = 10
                    self.imagePledge.clipsToBounds = true
                    
                }
            }
            
        }
        self.tableView.reloadData()
    }
    
    //download image in database
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) {
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            //print(image)
            completion(image_Field)
        }
    }
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
}
