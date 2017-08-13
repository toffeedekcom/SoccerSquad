//
//  AcceptinvitationTableViewController.swift
//  Project2
//
//  Created by toffee on 6/17/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AcceptinvitationTableViewController: UITableViewController {
    
    var nameTeam = ""
    var mid = ""
    var imageTeam = ""
    var headName = ""
    var tid = ""
    var uid = ""
    
    var sendTid = "" //ส่ง id ทีม
    var sendUid = "" //ส่ง id หัวหน้าทีม
    var sendNameTeam = "" //ส่งชื่อทีม
    
    var addNameTeam = [String]()
    var addmid = [String]()
    var addImageTeam = [String]()
    var addHeadName = [String]()
    var addTid = [String]()
    var addUid = [String]()
    
    var refresh = UIRefreshControl()
    var dateFormatter = NSDateFormatter()


    override func viewDidLoad() {
        
        
        print("numxx = \(self.tabBarController?.tabBarItem.tag)")
        print("tabBarAccept = \(tabBarController?.selectedIndex)")
        super.viewDidLoad()
//        self.addNameTeam = []
//        self.addmid = []
//        self.addImageTeam = []
//        self.addHeadName = []
//        self.addTid = []
//        self.addUid = []
//      
//        self.tableView.reloadData()
        self.listAccept()
       
     }
    
    
    func listAccept() {
        
        self.addNameTeam = []
        self.addmid = []
        self.addImageTeam = []
        self.addHeadName = []
        self.addTid = []
        self.addUid = []
        var parameter:[String:String] = ["uid":userId]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/accept/acceptInvitation.php"
        Alamofire.request(.GET,urlSring ,parameters: parameter,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                     self.headName  = (value["uname"] as? String)!
                     self.nameTeam  = (value["tname"] as? String)!
                     self.imageTeam  = (value["timage"] as? String)!
                     self.mid  = (value["memteamid"] as? String)!
                     self.tid = (value["tid"] as? String)!
                     self.uid = (value["uid"] as? String)!
                    
                    self.addmid.append(self.mid)
                    self.addHeadName.append(self.headName)
                    self.addNameTeam.append(self.nameTeam)
                    self.addImageTeam.append(self.imageTeam)
                    self.addTid.append(self.tid)
                    self.addUid.append(self.uid)
                    
                }
                self.tableView.reloadData()
                let now = NSDate()
                
                let updateString = "Refresh... " + self.dateFormatter.stringFromDate(now)
                self.refresh.attributedTitle = NSAttributedString(string: updateString)
                
                self.refresh.addTarget(self, action: #selector(self.listAccept), forControlEvents: UIControlEvents.ValueChanged)

                self.refresh.endRefreshing()
                self.tableView.addSubview(self.refresh)
                
              print(self.addNameTeam)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("num =  \(self.addNameTeam.count)")
        return self.addNameTeam.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var urlImage = "https://nickgormanacademy.com/soccerSquat/image/" + addImageTeam[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell_accept
        
        cell.nameTeam.text = addNameTeam[indexPath.row]
        
        getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
            cell.imageTeam.image = image
            cell.imageTeam.contentMode = .ScaleAspectFit
            cell.imageTeam.layer.borderWidth = 1.0
            cell.imageTeam.layer.masksToBounds = false
            cell.imageTeam.layer.cornerRadius = cell.imageTeam.frame.size.height/2
            cell.imageTeam.clipsToBounds = true
        }
        cell.accept.tag = indexPath.row
        cell.accept.layer.cornerRadius = 12
        cell.accept.addTarget(self, action: "action:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.unaccept.tag = indexPath.row
        cell.unaccept.layer.cornerRadius = 12
        cell.unaccept.addTarget(self, action: "unAccept:", forControlEvents: UIControlEvents.TouchUpInside)



        return cell
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    func action(sender: UIButton) { //จะทำงานเมื่อกดปุ่ม yes
        print("YES")
        var mid = self.addmid[sender.tag]
        self.sendTid = self.addTid[sender.tag]
        self.sendUid = self.addUid[sender.tag]
        self.sendNameTeam = self.addNameTeam[sender.tag]
        let parame:[String:String] = ["mid": mid, "status": "YES"]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/accept/updateStatus.php"
        
        Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
        }
        //sender.enabled = false
        listAccept()
        self.performSegueWithIdentifier("accept", sender: sender)
        
    }
    
    func unAccept(sender: UIButton) { //จะทำงานเมื่อกดปุ่ม no
        print("NO")
        var mid = self.addmid[sender.tag]
        let parame:[String:String] = ["mid": mid, "status": "NO"]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/accept/updateStatus.php"
        
        Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
        }
        //sender.enabled = false

        self.viewDidLoad()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "accept") {
            let DestViewController = segue.destinationViewController as! DataTeam
           // let DestViewController = navController.topViewController as! DataTeam
            DestViewController.id_team = self.sendTid
            DestViewController.uid = self.sendUid
            DestViewController.name = self.sendNameTeam
            
        }
               
        
        
    }


}
