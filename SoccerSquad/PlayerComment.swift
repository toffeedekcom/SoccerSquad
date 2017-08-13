//
//  PlayerComment.swift
//  Project2
//
//  Created by toffee on 6/26/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PlayerComment: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messenger: UITextField!
    
    
    var uid1 = "" //รับมาจาก DataUserComment
    
    var comment = ""
    var image = ""
    var uid2 = ""
    
    var addComment = [String]()
    var addImage = [String]()
    var addUid2 = [String]()
    
    var sum = 10
    var num = 0
    
    var timer  = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addComment = []
        self.addImage = []
        self.addUid2 = []
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.dolistPlayer()
         timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(PlayerComment.update), userInfo: nil, repeats: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func update() {
        print("number = \(num)")
        // self.tableView.reloadData()
        
        if(num == sum){
            self.dolistPlayer()
            sum = sum+10
            
        }
        self.num++
    }

    
    func dolistPlayer() {
        
        self.addComment = []
        self.addImage = []
        self.addUid2 = []
        
        
        let urlCommentOwner = "https://nickgormanacademy.com/soccerSquat/comment/PlayerComment/RequestCommentPleyer.php"
        var parame:[String:String] = ["uid": self.uid1]
        Alamofire.request(.GET,urlCommentOwner,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.comment  = (value["cuserdetail"] as? String)!
                        self.image  = (value["uimage"] as? String)!
                        self.uid2 = (value["uid"] as? String)!
                        
                        
                        self.addComment.append(self.comment)
                        self.addImage.append(self.image)
                        self.addUid2.append(self.uid2)
                        
                        
                        
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
        
        if(uid1 == addUid2[indexPath.row]){
            let cell1 = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! PlayerCommemtCell
            
            cell1.viewUser1.layer.cornerRadius = 12
            cell1.commentUser1.text = self.addComment[indexPath.row]
            cell1.commentUser1.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell1.commentUser1.numberOfLines = 0
            
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImage[indexPath.row]
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell1.imageUser1.image = image
                cell1.imageUser1.contentMode = .ScaleAspectFit
                cell1.imageUser1.layer.borderWidth = 1.0
                cell1.imageUser1.layer.masksToBounds = false
                cell1.imageUser1.layer.cornerRadius = cell1.imageUser1.frame.size.height/2
                cell1.imageUser1.clipsToBounds = true
            }

            
            return cell1
        }else{
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! PlayerCommemtCell
            
            cell2.viewUser2.layer.cornerRadius = 12
            cell2.commentUser2.text = self.addComment[indexPath.row]
            cell2.commentUser2.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell2.commentUser2.numberOfLines = 0
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImage[indexPath.row]
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell2.imageUser2.image = image
                cell2.imageUser2.contentMode = .ScaleAspectFit
                cell2.imageUser2.layer.borderWidth = 1.0
                cell2.imageUser2.layer.masksToBounds = false
                cell2.imageUser2.layer.cornerRadius = cell2.imageUser2.frame.size.height/2
                cell2.imageUser2.clipsToBounds = true
            }
            
            return cell2

        
        }
    }

     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func send(sender: AnyObject) {
        
        print("xxxxxxxxx")
        let urlCommentOwner = "https://nickgormanacademy.com/soccerSquat/comment/PlayerComment/SendMessengerPlayer.php"
        var parame:[String:String] = ["uid1": self.uid1, "uid2":userId, "detail":self.messenger.text!]
        Alamofire.request(.GET,urlCommentOwner,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
        }
    }
    
   
    
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }

    @IBAction func back(sender: AnyObject) {
         timer.invalidate()
        self.performSegueWithIdentifier("back", sender: self)
        
    }
    

   
}
