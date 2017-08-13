//
//  DetailReport.swift
//  Project2
//
//  Created by toffee on 7/9/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailReport: UITableViewController {
    
    var rid = ""
    
    @IBOutlet weak var toPic: UILabel!
    @IBOutlet weak var imageReport: UIImageView!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(rid)
        self.doDetail()
       
    }
    
    func doDetail(){
        
        var parameter:[String:String] = [ "rid":rid]
        let urlDetailReport = "https://nickgormanacademy.com/soccerSquat/admin/report/DetailReport.php"
        
        Alamofire.request(.GET,urlDetailReport ,parameters: parameter,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.toPic.text  = (value["report_topic"] as? String)!
                    self.detail.text  = (value["report_detail"] as? String)!
                    self.date.text  = (value["report_date"] as? String)!

                    var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + (value["report_image"] as? String)!
                    
                    self.getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                        self.imageReport.image = image
                        self.imageReport.contentMode = .ScaleAspectFit
                        self.imageReport.layer.borderWidth = 1.0
                        self.imageReport.layer.masksToBounds = false
                        //self.imageReport.layer.cornerRadius = self.imageReport.frame.size.height/2
                        self.imageReport.clipsToBounds = true
                    }
                }
                //print(self.addNamePlayer)
                
                self.tableView.reloadData()
                
                
        }

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }

   
}
