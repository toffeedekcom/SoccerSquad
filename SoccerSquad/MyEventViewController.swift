//
//  MyEventViewController.swift
//  Project2
//
//  Created by toffee on 6/24/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MyEventViewController: UIViewController {
    
    @IBOutlet weak var imgaeTeam: UIImageView!
    
    @IBOutlet weak var nameEvent: UILabel!
    @IBOutlet weak var nameTeam: UILabel!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    
    
    
    
    
    
    var playerId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.doDataEvent()
        print("MyEvent\(playerId)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doDataEvent() {
        var urlMyEvent = "https://nickgormanacademy.com/soccerSquat/event/MyEvent.php"
        var parameter:[String:String] = [ "pid":playerId]
        
        Alamofire.request(.GET,urlMyEvent ,parameters: parameter, encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                
                for value in JSON {
                   
                     self.nameEvent.text  = (value["playername"] as? String)!
                     self.nameTeam.text  = (value["tname"] as? String)!
                     self.detail.text  = (value["playerdetail"] as? String)!
                     self.date.text = (value["playerdate"] as? String)!
                     self.location.text = (value["fname"] as? String)!
                    
                    var urlImage = "https://nickgormanacademy.com/soccerSquat/image/" + (value["timage"] as? String)!
                    
                    
                    self.getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                        self.imgaeTeam.image = image
                        self.imgaeTeam.contentMode = .ScaleAspectFit
                        self.imgaeTeam.layer.borderWidth = 1.0
                        self.imgaeTeam.layer.masksToBounds = false
                        self.imgaeTeam.layer.cornerRadius = self.imgaeTeam.frame.size.height/2
                        self.imgaeTeam.clipsToBounds = true
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
    
    
    @IBAction func edit(sender: AnyObject) {
        
        performSegueWithIdentifier("editevent", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editevent") {
            let DestViewController = segue.destinationViewController as! MyEventEditTableViewController
            
            DestViewController.playerId = playerId
            
        }
    }

}
