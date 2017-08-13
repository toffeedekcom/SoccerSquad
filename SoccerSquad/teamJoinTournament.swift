//
//  teamJoinTournament.swift
//  Project2
//
//  Created by toffee on 6/29/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

protocol getField {
    func getplaceID(tid: String)
    func getplaceName(tname: String)
}

class teamJoinTournament: UITableViewController {

    var tid = ""
    var nameTeam = ""
    var nameImageTeam = ""
    
    var addTid = [String]()
    var addNameTeam = [String]()
    var addNameImageTeam = [String]()
    
    var date = ""
    var nameEvent = ""
    var detail = ""
    var fid = ""
    var nameField = ""
    
    var delegate: getField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doTeam()
        
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
        return addNameTeam.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? teamJoinTournamentCell
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/image/" + addNameImageTeam[indexPath.row]
        
        cell?.nameTeam.text = addNameTeam[indexPath.row]
        getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
            cell!.imageTeam.image = image
            cell!.imageTeam.contentMode = .ScaleAspectFit
            cell!.imageTeam.layer.borderWidth = 1.0
            cell!.imageTeam.layer.masksToBounds = false
            cell!.imageTeam.layer.cornerRadius = cell!.imageTeam.frame.size.height/2
            cell!.imageTeam.clipsToBounds = true
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        self.tid = addTid[indexPath.row]
        self.nameTeam = addNameTeam[indexPath.row]
        
        self.delegate?.getplaceID(self.addTid[indexPath.row])
        self.delegate?.getplaceName(self.addNameTeam[indexPath.row])

        
        //performSegueWithIdentifier("sendParameterTeam", sender: self)
    }
    
    
    
    func doTeam() {
        let urlFieldAll = "https://nickgormanacademy.com/soccerSquat/event/TeamEvent.php"
        var parame:[String:String] = ["uid": userId]
        
        Alamofire.request(.GET,urlFieldAll,parameters: parame  ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.tid  = (value["tid"] as? String)!
                    self.nameTeam  = (value["tname"] as? String)!
                    self.nameImageTeam  = (value["timage"] as? String)!
                    
                    self.addTid.append(self.tid)
                    self.addNameTeam.append(self.nameTeam)
                    self.addNameImageTeam.append(self.nameImageTeam)
                    
                }
                print(self.addNameImageTeam)
                self.tableView.reloadData()
                
                
        }
        
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
}
