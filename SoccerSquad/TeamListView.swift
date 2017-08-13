//
//  TeamListView.swift
//  Project2
//
//  Created by Jay on 7/7/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class TeamListView: UITableViewController {
    
    //data segue
    var team_id = [String]()
    var tour_id = ""
    
    //getdatabase
    var team_name = ""
    var team_image = ""
    var join_date = ""
    
    
    
    
    var arrTeam_name = [String]()
    var arrTeam_image = [String]()
    var arrJoin_Date = [String]()
    
    var get_tid = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrTeam_name = []
        self.arrTeam_image = []
        self.arrJoin_Date = []
        self.tableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.refreshControl?.addTarget(self, action: #selector(TeamListView.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.separatorColor = UIColor.clearColor()
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.selectTeam()
                }else if(net?.isReachableOnWWAN)! {
                    self.selectTeam()
                }else {
                    print("unknow")
                }
            }
            else {
                self.MyAlerts("No internet connnection")
                print("no connection")
            }
            
        }
        
        
    }
    
    func selectTeam() {
        self.arrTeam_name = []
        self.arrTeam_image = []
        self.arrJoin_Date = []
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectJoinTeam.php"
        var parameter:[String:String] = ["tourid": tour_id]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    self.MyAlerts("Team join tournament is empty!")
                }else {
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.team_name = (value["tname"] as? String)!
                        self.team_image = (value["timage"] as? String)!
                        self.join_date = (value["jointourdate"] as? String)!
                        
                        self.arrTeam_name.append(self.team_name)
                        self.arrTeam_image.append(self.team_image)
                        self.arrJoin_Date.append(self.join_date)
                    }
                }
                
                self.tableView.reloadData()
        }
    
    }
    
    func getRemoveTeam() {
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/removeTeamTour.php"
        var parameter:[String:String] = ["tid": get_tid]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                self.MyAlerts("Remove Team Success")
                
                
        }
        self.tableView.reloadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        selectTeam()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
    
    func More() {
        let alert = UIAlertController(title: "More",message: "Choose your functions.",preferredStyle: .Alert)
        
        let action2 = UIAlertAction(title: "Remove Team", style: .Default, handler: { (action) -> Void in
            print("ACTION 2 selected!")
            
            let alertController = UIAlertController(title: "Confirm!", message: "Ara you sure remove team from tournament ?", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                print("Perform Remove action")
                self.getRemoveTeam()
            })
            
            let deleteAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: {(ACTION) in
                print("Perform Cancel action")
            })
            
            alertController.addAction(okAction)
            alertController.addAction(deleteAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
            alertController.view.layer.cornerRadius = 25
        })
        
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action) -> Void in })
        
        // Add action buttons and present the Alert
        alert.addAction(action2)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
        // Restyle the view of the Alert
        alert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0) // change text color of the buttons
        
        alert.view.layer.cornerRadius = 25   // change corner radius

    }
    
    //Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()

        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        
        return arrTeam_name.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("teamCell", forIndexPath: indexPath) as! UI
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            myCell.Name.text = arrTeam_name[indexPath.row]
            myCell.date.text = arrJoin_Date[indexPath.row]
            
            myCell.tapAction = { [weak self] (cell) in
                print(tableView.indexPathForCell(cell)!.row)
                
                self!.get_tid = self!.team_id[indexPath.row]
                print(self!.get_tid)
                
                self!.More()
            }
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/image/" + arrTeam_image[indexPath.row]
            
            if urlImage.isEmpty {
                myCell.ImageView.image = UIImage(named: "team")
            }else {
                
                downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                    
                    if image == nil {
                        myCell.ImageView.image = UIImage(named: "team")
                        
                    }else {
                        
                        myCell.ImageView.image = image
                        myCell.ImageView.contentMode = .ScaleAspectFill
                        myCell.ImageView.layer.borderWidth = 1.0
                        myCell.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                        myCell.ImageView.layer.masksToBounds = false
                        myCell.ImageView.layer.cornerRadius = 45
                        myCell.ImageView.clipsToBounds = true
                        
                    }
                }
                
            }
  
        }
        else {
            
            print("Internet connection FAILED")
            tableView.reloadData()
//            MyAlerts("Make sure your device is connected to the internet.")
            
        }

        return myCell
        
    }

    

}

class UI: UITableViewCell {
    var tapAction: ((UITableViewCell) -> Void)?
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBAction func MoreAction(sender: AnyObject) {
         tapAction?(self)
        
    }
}
