//
//  myTeam.swift
//  ParseDemo
//
//  Created by toffee on 5/24/2560 BE.
//  Copyright © 2560 abearablecode. All rights reserved.
//

import UIKit
import Alamofire

class myTeam: UITableViewController {
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let urlSring = "https://nickgormanacademy.com/soccerSquat/team/myTeam.php"
    var data = [String]()
    var addUid = [String]()
    var addTid = [String]()
    var addDetailTeam = [String]()
    var addTimage = [String]()
    
    var uid = ""
    var tid = ""
    var tname = ""
    var detailTeam = ""
    var timage = ""
    
    var segmemt = 0
    
    
    

    
    var myIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmemt = 0
         print("tabBarMyteam = \(tabBarController?.selectedIndex)")
        var parame:[String:String] = ["uid": userId, "segmemt":"1"]
        Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.uid  = (value["uid"] as? String)!
                    self.tid  = (value["tid"] as? String)!
                    self.tname = (value["tname"] as? String)!
                    self.detailTeam = (value["tdetail"] as? String)!
                    self.timage = (value["timage"] as? String)!
                    self.data.append(self.tname)
                    self.addUid.append(self.uid)
                    self.addTid.append(self.tid)
                    self.addDetailTeam.append(self.detailTeam)
                    self.addTimage.append(self.timage)
                    
                }
                self.tableView.reloadData()
                
        }

    }
    
    
    @IBAction func segmentTeam(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            var parame:[String:String] = ["uid": userId, "segmemt":"1"]
            self.segmemt = 0
            self.data = []
            self.addTid = []
            self.addUid = []
            self.addDetailTeam = []
            self.addTimage = []

            Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
                .responseJSON{(response) in
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        
                        self.uid  = (value["uid"] as? String)!
                        self.tid  = (value["tid"] as? String)!
                        self.tname = (value["tname"] as? String)!
                        self.detailTeam = (value["tdetail"] as? String)!
                        self.timage = (value["timage"] as? String)!
                        self.data.append(self.tname)
                        self.addUid.append(self.uid)
                        self.addTid.append(self.tid)
                        self.addDetailTeam.append(self.detailTeam)
                        self.addTimage.append(self.timage)
                    }
                    self.tableView.reloadData()
                    
            }
            print("First")
        case 1:
            var parame1:[String:String] = ["uid": userId, "segmemt":"2"]
            self.segmemt = 1
            self.data = []
            self.addTid = []
            self.addUid = []
            self.addDetailTeam = []
            Alamofire.request(.GET,urlSring ,parameters: parame1 ,encoding: .URL).validate()
                .responseJSON{(response) in
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.uid  = (value["uid"] as? String)!
                        self.tid  = (value["tid"] as? String)!
                        self.tname = (value["tname"] as? String)!
                        self.detailTeam = (value["tdetail"] as? String)!
                        self.timage = (value["timage"] as? String)!
                        self.data.append(self.tname)
                        self.addUid.append(self.uid)
                        self.addTid.append(self.tid)
                        self.addDetailTeam.append(self.detailTeam)
                        self.addTimage.append(self.timage)
                    }
                    self.tableView.reloadData()
                    print("second = \(self.data)")
            }
            
        default:
            break; 
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("sum = \(data.count)")
        

        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! myTeamCell
        cell.nameTeam.text = data[indexPath.row]
        
        
        print("n = \(indexPath.row)")
        
         var urlImage = "https://nickgormanacademy.com/soccerSquat/image/" + addTimage[indexPath.row]
        
        getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
            cell.showImage.image = image
            cell.showImage.contentMode = .ScaleAspectFill
            cell.showImage.layer.borderWidth = 1.0
            cell.showImage.layer.masksToBounds = false
            cell.showImage.layer.cornerRadius = cell.showImage.frame.size.height/2
            cell.showImage.clipsToBounds = true
        }
        
        
//        if(self.segmemt == 1){
//                let btnCancel: UIButton = UIButton(frame: CGRectMake(240, 10, 40, 40))
//                btnCancel.setImage(UIImage(named: "icon_cancel"), forState: UIControlState.Normal)
//                btnCancel.tag = indexPath.row
//                btnCancel.addTarget(self, action: "buttonCancelMember:", forControlEvents: UIControlEvents.TouchUpInside)
//                cell.addSubview(btnCancel)
//            
//                        
//        }


        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.myIndex = indexPath.row
        performSegueWithIdentifier("segue", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "segue") {
            let DestViewController = segue.destinationViewController as! DataTeam
            //let DestViewController = navController.topViewController as! DataTeam
            DestViewController.name = self.data[self.myIndex]
            DestViewController.id_team = self.addTid[self.myIndex]
            DestViewController.uid = self.addUid[self.myIndex]
            DestViewController.detailTeam = self.addDetailTeam[self.myIndex]
        }
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    func buttonCancelMember(sender: UIButton) {
        
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Confirm ", message: "you want to team out ?", preferredStyle: .Alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            let urlDelMember = "https://nickgormanacademy.com/soccerSquat/team/deleteMember.php"
            let parame3:[String:String] = ["tid": self.addTid[sender.tag] ,"uid":userId ]
            Alamofire.request(.GET, urlDelMember, parameters: parame3, encoding: .URL).validate()
                .responseJSON{(response) in
                    
            }
            
            self.refresh()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func refresh(){
        
        var parame1:[String:String] = ["uid": userId, "segmemt":"2"]
        self.segmemt = 1
        self.data = []
        self.addTid = []
        self.addUid = []
        self.addDetailTeam = []
        Alamofire.request(.GET,urlSring ,parameters: parame1 ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.uid  = (value["uid"] as? String)!
                    self.tid  = (value["tid"] as? String)!
                    self.tname = (value["tname"] as? String)!
                    self.detailTeam = (value["tdetail"] as? String)!
                    self.timage = (value["timage"] as? String)!
                    self.data.append(self.tname)
                    self.addUid.append(self.uid)
                    self.addTid.append(self.tid)
                    self.addDetailTeam.append(self.detailTeam)
                    self.addTimage.append(self.timage)
                }
                self.tableView.reloadData()
                print("second = \(self.data)")
        }

    }
    
    @IBAction func unwindToMyTame(segue: UIStoryboardSegue) {
        self.segmentTeam(self)
    }


  
}
