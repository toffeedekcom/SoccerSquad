//
//  accept.swift
//  ParseDemo
//
//  Created by toffee on 11/21/2559 BE.
//  Copyright © 2559 abearablecode. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class accept: UITableViewController {
    
  //let data = accept()
   
    
    
    let urlString = "https://nickgormanacademy.com/soccerSquat/accept.php"
    var name_team = "";
     var id_invite = "";
    var id_corrom = ""
    
      var data_id = [String]()
     var id_invit = [String]()
     var data = [String]()
    var pp = [String]()
    
    
    var data_invilt = [String]()
    
    override func viewDidLoad() {
         let parame:[String:String] = ["user_id" : user_id]
        //let parame:[String:String] = ["user_id": getid, "head": user_id, "name_team": NameTeam, "id_team": IDTeam]
         print("user_id = \(user_id)")
        
        Alamofire.request(.GET,urlString ,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.name_team  = (value["name_team"] as? String)! //idของคนถูกเชิญ
                     self.id_invite  = (value["id_invite"] as? String)!
                    
                    
                    self.data_id.append(self.name_team)
                    self.id_invit.append(self.id_invite)
                  
                }
                 print("id = \(self.data_id)")
                 self.tableView.reloadData()
        }
        
          //  data_id = ["gg","AAA"]
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ff = \(self.data_id.count)")
        return self.data_id.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("pp")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell_accept
        cell.textLabel!.text = data_id[indexPath.row]
        
         cell.accept.addTarget(self, action: "action:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
        
    }
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
              id_corrom = self.id_invit[indexPath.row]
   
    print(id_corrom)
   }
   
    
    func action(sender: UIButton) { //จะทำงานเมื่อกดปุ่ม invlit
        let parame:[String:String] = ["id_invite": id_corrom]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/update_invite.php"
        
        Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                print("jj")
                
                
        }
        
        
    }
    


   
}
