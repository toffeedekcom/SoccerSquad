//
//  PaySeccess.swift
//  Project2
//
//  Created by toffee on 7/3/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PaySeccess: UITableViewController {
    var bookId = ""
    
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var imageType: UIImageView!
    @IBOutlet weak var typeMiniField: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var stopTime: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var pledge: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("bookId = \(self.bookId)")

        self.doPaySeccess()
    }
    
    func doPaySeccess(){
        
        
        let urlStatusBook = "https://nickgormanacademy.com/soccerSquat/booking/StatusBook.php"
        var parame:[String:String] = ["bookId": self.bookId]
        Alamofire.request(.GET,urlStatusBook,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.nameField.text  = (value["fname"] as? String)!
                        self.startTime.text  = (value["bstartime"] as? String)!
                        self.stopTime.text = (value["bstoptime"] as? String)!
                        self.date.text = (value["bdate"] as? String)!
                        self.status.text = (value["bstatus"] as? String)!
                        self.typeMiniField.text = (value["mnf_type"] as? String)!
                        self.price.text = (value["bprice"] as? String)!
                        self.pledge.text = (value["bpledge"] as? String)!
                        
                        
                        var urlImageField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + (value["fimage"] as? String)!
                        
                        
                        self.getNetworkImage(urlImageField) { (image) in //เรียก เมอธอทดึงรูป
                            self.imageField.image = image
                            self.imageField.contentMode = .ScaleAspectFit
                            self.imageField.layer.borderWidth = 1.0
                            self.imageField.layer.masksToBounds = false
                            self.imageField.layer.cornerRadius = self.imageField.frame.size.height/2
                            self.imageField.clipsToBounds = true
                        }
                        
                        
                        var urlImageTypeField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + (value["mnf_image"] as? String)!
                        
                        
                        self.getNetworkImage(urlImageTypeField) { (image) in //เรียก เมอธอทดึงรูป
                            self.imageType.image = image
                            self.imageType.contentMode = .ScaleAspectFit
                            self.imageType.layer.borderWidth = 1.0
                            self.imageType.layer.masksToBounds = false
                            self.imageType.layer.cornerRadius = self.imageType.frame.size.height/2
                            self.imageType.clipsToBounds = true
                        }
                        


                        
                        
                    }
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
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }


    
}
