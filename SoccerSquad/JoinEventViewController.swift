//
//  JoinEventViewController.swift
//  Project2
//
//  Created by toffee on 6/24/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class JoinEventViewController: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
   
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var playerId = ""
    var tid = ""
    var headUid = ""
    var nameTeam = ""
    
    var amount = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.doJoin()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doJoin() {
        print("playerId = \(playerId)")
        var urlMyEvent = "https://nickgormanacademy.com/soccerSquat/event/MyEvent.php"
        var parameter:[String:String] = [ "pid":playerId]
        
        Alamofire.request(.GET,urlMyEvent ,parameters: parameter, encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                
                for value in JSON {
                    
                    self.name.text  = (value["playername"] as? String)!
                    self.nameTeam  = (value["tname"] as? String)!
                    self.detail.text  = (value["playerdetail"] as? String)!
                    self.date.text = (value["playerdate"] as? String)!
                    self.location.text = (value["fname"] as? String)!
                    self.tid = (value["tid"] as? String)!
                    self.headUid = (value["uid"] as? String)!
                    self.amount = (value["playeramount"] as? String)!
                    
                    
                    var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + (value["fimage"] as? String)!
                    
                    
                    self.getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                        self.image.image = image
                        self.image.contentMode = .ScaleAspectFit
                        self.image.layer.borderWidth = 1.0
                        self.image.layer.masksToBounds = false
                        self.image.layer.cornerRadius = self.image.frame.size.height/2
                        self.image.clipsToBounds = true
                    }
                    
                    
                }
                
                
        }
    }
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    @IBAction func joinTeme(sender: AnyObject) {
        
       
        var urlJoin = "https://nickgormanacademy.com/soccerSquat/event/JoinEvent.php"
        var parameter:[String:String] = [ "uid":userId, "tid":self.tid, "playerid":self.playerId]
        
        Alamofire.request(.GET,urlJoin ,parameters: parameter, encoding: .URL).validate()
            .responseJSON{(response) in
                        }
        
        performSegueWithIdentifier("joinevent", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "joinevent") {
            let DestViewController = segue.destinationViewController as! DataTeam
            
            DestViewController.id_team = self.tid
            DestViewController.uid = headUid
            DestViewController.name = self.nameTeam
            DestViewController.key = "chackJoinEvent"  
            DestViewController.amount = self.amount
            DestViewController.playerId = self.playerId
            
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
