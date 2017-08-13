//
//  ListTeamTournament.swift
//  Project2
//
//  Created by toffee on 7/12/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ListTeamTournament: UITableViewController {
    
    var tourId = ""
    
    var nameTeam =  ""
    var imageTeam = ""
    
    var addNameTeam = [String]()
    var addImageTeam = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("tourId = \(tourId)")
        self.doListTeam()
    }
    
    func doListTeam(){
        var urlListTeam = "https://nickgormanacademy.com/soccerSquat/event/eventtournament/ListTeam.php"
        var parameCheckTour:[String:String] = [ "tournamentId":self.tourId]
        //var parameTeam:[String:String] = [ "tid":self.tid ]

        
        Alamofire.request(.GET,urlListTeam,parameters: parameCheckTour , encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    
                    for value in JSON {
                        self.nameTeam  = (value["tname"] as? String)!
                        self.imageTeam = (value["timage"] as? String)!
                        
                        self.addNameTeam.append(self.nameTeam)
                        self.addImageTeam.append(self.imageTeam)
                       
                    }
                    print(self.addNameTeam)
                    self.tableView.reloadData()
                    
                case .Failure(let error):
                    print(error)
                }
                
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
        return addNameTeam.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTeamCell
        
        cell.nameTeam.text = addNameTeam[indexPath.row]
        var urlImageTeam = "https://nickgormanacademy.com/soccerSquat/image/" + addImageTeam[indexPath.row]
        
        self.getNetworkImage(urlImageTeam) { (image) in //เรียก เมอธอทดึงรูป
            cell.imageTeam.image = image
            cell.imageTeam.contentMode = .ScaleAspectFit
            cell.imageTeam.layer.borderWidth = 1.0
            cell.imageTeam.layer.masksToBounds = false
            cell.imageTeam.layer.cornerRadius = cell.imageTeam.frame.size.height/2
            cell.imageTeam.clipsToBounds = true
            
        }

        // Configure the cell...

        return cell
    }
    

    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
}
class ListTeamCell: UITableViewCell {
    
    @IBOutlet weak var imageTeam: UIImageView!
    @IBOutlet weak var nameTeam: UILabel!
    
    
}
