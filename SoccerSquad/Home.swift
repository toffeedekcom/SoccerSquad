//
//  Home.swift
//  Project2
//
//  Created by toffee on 7/13/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class Home: UITableViewController {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var birthday: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var countEvent: UILabel!
    @IBOutlet weak var countTeam: UILabel!
    
    var refresh = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        self.countEventAndTeam()
        get_data()
    }
    func countEventAndTeam(){
        var nameEvent = ""
        var addNameEvent = [String]()
        var countEvent = 0
        
        var urlSegment = "https://nickgormanacademy.com/soccerSquat/event/chackEvent.php"
        var parameter:[String:String] = [ "uid":userId , "segmemted":"1"]
        Alamofire.request(.GET,urlSegment ,parameters: parameter, encoding: .URL).validate()
            .responseJSON{(response) in
                switch response.result {
                case .Success:
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        nameEvent  = (value["playername"] as? String)!
                        addNameEvent.append(nameEvent)
                    }
                    countEvent = addNameEvent.count
                    self.countEvent.text = String(countEvent)
                case .Failure(let error):
                    print(error)
                }
                
        }
        
        
        //////////////////////////////////
        var tname = ""
        var data = [String]()
        var countTeam = 0
        let urlSring = "https://nickgormanacademy.com/soccerSquat/team/myTeam.php"
        var parame:[String:String] = ["uid": userId, "segmemt":"1"]
        Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    
                    tname = (value["tname"] as? String)!
                    
                    data.append(tname)
                    
                }
                countTeam = data.count
                self.countTeam.text = String(countTeam)
                
        }
        
        
    }
    func get_data(){
        
        self.btnEdit.layer.borderWidth = 1.0
        self.btnEdit.layer.cornerRadius = 12
        self.btnEdit.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
        let parame:[String:String] = ["uid": userId, ]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/home/getDataUser.php"
        Alamofire.request(.GET,urlSring, parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Empty Data")
                }
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    self.name.text  = (value["uname"] as? String)!
                    self.email.text  = (value["uemail"] as? String)!
                    self.sex.text  = (value["usex"] as? String)!
                    self.statusTextView.text = (value["ustatus"] as? String)!
                    self.positionLabel.text = (value["uposition"] as? String)!
                    self.birthday.text = (value["ubirthday"] as? String)!
                    print("xxx = \((value["ubirthday"] as? String)!)")
                    self.navigationItem.title = self.name.text
                    var urlString = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/"+(value["uimage"]as? String)!
                    self.getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
                        self.imageUser.layer.borderWidth = 1.0
                        self.imageUser.layer.masksToBounds = false
                        self.imageUser.contentMode = .ScaleAspectFill
                        self.imageUser.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
                        self.imageUser.layer.cornerRadius = self.imageUser.frame.size.height/2
                        self.imageUser.clipsToBounds = true
                        self.imageUser.image = image
                        
                    }
                    
                }
                let now = NSDate()
                let updateString = "Refresh... " + self.dateFormatter.stringFromDate(now)
                self.refresh.attributedTitle = NSAttributedString(string: updateString)
                
                self.refresh.addTarget(self, action: #selector(self.get_data), forControlEvents: UIControlEvents.ValueChanged)
                
                self.refresh.endRefreshing()
                self.tableView.addSubview(self.refresh)
                
        }
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            completion(image)
        }
    }
    
    @IBAction func search(sender: AnyObject) {
        performSegueWithIdentifier("searchuser", sender: self)
    }
    
    @IBAction func setting(sender: AnyObject) {
        performSegueWithIdentifier("setting", sender: self)
    }
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        print("update")
        self.get_data()
    }
    
}
