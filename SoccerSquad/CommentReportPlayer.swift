//
//  CommentReportPlayer.swift
//  Project2
//
//  Created by toffee on 7/8/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CommentReportPlayer: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var comment = ""
    var image = ""
    var uid = ""
    
    var sum = 10
    var num = 0
    
    var addComment = [String]()
    var addImage = [String]()
    var addUid = [String]()
    var timer  = NSTimer()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messenger: UITextField!
    @IBOutlet weak var customButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
         addComment = []
         addImage = []
         addUid = []
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.customButton.layer.cornerRadius = 5
        self.doReport()
         timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(PlayerComment.update), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    func update() {
        print("number = \(num)")
            if(num == sum){
                self.doReport()
                sum = sum+10
            }
            self.num++
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doReport(){
    
        
         addComment = []
         addImage = []
         addUid = []
       

        let urlCommentUser = "https://nickgormanacademy.com/soccerSquat/comment/PlayerComment/RequestCommentPleyer.php"
        var parame:[String:String] = ["uid": userId]
        Alamofire.request(.GET,urlCommentUser,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.comment  = (value["cuserdetail"] as? String)!
                        self.image  = (value["uimage"] as? String)!
                        self.uid  = (value["uid"] as? String)!
                        
                        self.addComment.append(self.comment)
                        self.addImage.append(self.image)
                        self.addUid.append(self.uid)
                       
                        
                        
                        
                    }
                    print(self.addComment)
                    self.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }
        
    
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addComment.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(userId == addUid[indexPath.row]){ 
            let cell1 = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CommentReportPlayerCell
            
            cell1.commentHead.text = self.addComment[indexPath.row]
            cell1.commentHead.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell1.commentHead.numberOfLines = 0
            cell1.commentHead.layer.cornerRadius = 10
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImage[indexPath.row]
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell1.imageHead.image = image
                cell1.imageHead.contentMode = .ScaleAspectFill
                cell1.imageHead.layer.borderWidth = 1.0
                cell1.imageHead.layer.masksToBounds = false
                cell1.imageHead.layer.cornerRadius = cell1.imageHead.frame.size.height/2
                cell1.imageHead.clipsToBounds = true
            }
            
            
            return cell1
        }else{
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! CommentReportPlayerCell
            
            cell2.commentGeneral.text = self.addComment[indexPath.row]
            cell2.commentGeneral.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell2.commentGeneral.numberOfLines = 0
            cell2.commentGeneral.layer.cornerRadius = 10
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImage[indexPath.row]
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell2.imageGeneral.image = image
                cell2.imageGeneral.contentMode = .ScaleAspectFill
                cell2.imageGeneral.layer.borderWidth = 1.0
                cell2.imageGeneral.layer.masksToBounds = false
                cell2.imageGeneral.layer.cornerRadius = cell2.imageGeneral.frame.size.height/2
                cell2.imageGeneral.clipsToBounds = true
            }
            
            return cell2
            
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }

    
    @IBAction func send(sender: AnyObject) {
        let urlCommentOwner = "https://nickgormanacademy.com/soccerSquat/comment/PlayerComment/SendMessengerPlayer.php"
        var parame:[String:String] = ["uid1": userId, "uid2":userId, "detail":self.messenger.text!]
        Alamofire.request(.GET,urlCommentOwner,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
        }
        self.messenger.text = ""
        
    }
    

}

class CommentReportPlayerCell: UITableViewCell {
    
    @IBOutlet weak var commentHead: UILabel!
    @IBOutlet weak var imageHead: UIImageView!
    
    @IBOutlet weak var commentGeneral: UILabel!
    @IBOutlet weak var imageGeneral: UIImageView!
    
    
}
