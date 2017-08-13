//
//  NEW_Comments.swift
//  SoccerSquad
//
//  Created by CSmacmini on 7/25/2560 BE.
//  Copyright © 2560 Project. All rights reserved.
//

import UIKit
import Alamofire

class NEW_Comments: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messenger: UITextField!
    
    var fid = ""
    
    
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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NEW_Comments.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        self.addComment = []
        self.addImage = []
        self.addUid2 = []
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.dolistPlayer()
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(PlayerComment.update), userInfo: nil, repeats: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        self.dolistPlayer()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
        
        
        let urlCommentOwner = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/ViewCommentsFIeld.php"
        var parame:[String:String] = ["fid": self.fid]
        Alamofire.request(.GET,urlCommentOwner,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.comment  = (value["cfielddetail"] as? String)!
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
        
        if(uid1 != addUid2[indexPath.row]){
            let cell1 = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! commentCells
            cell1.commentUser1.layer.borderWidth = 1.0
            cell1.commentUser1.layer.borderColor = UIColor.clearColor().CGColor
            cell1.commentUser1.layer.cornerRadius = 7
            cell1.commentUser1.layer.masksToBounds = false
            cell1.commentUser1.clipsToBounds = true
            cell1.commentUser1.text = " "+self.addComment[indexPath.row]
            cell1.commentUser1.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell1.commentUser1.numberOfLines = 0
            
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImage[indexPath.row]
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell1.imageUser1.image = image
                cell1.imageUser1.contentMode = .ScaleAspectFill
                cell1.imageUser1.layer.borderWidth = 1.0
                cell1.imageUser1.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
                cell1.imageUser1.layer.masksToBounds = false
                cell1.imageUser1.layer.cornerRadius = 10
                cell1.imageUser1.clipsToBounds = true
            }
            
            
            return cell1
        }else{
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("commentCell2", forIndexPath: indexPath) as! commentCells
            cell2.commentUser2.layer.borderWidth = 1.0
            cell2.commentUser2.layer.cornerRadius = 7
            cell2.commentUser2.layer.borderColor = UIColor.clearColor().CGColor
            cell2.commentUser2.layer.masksToBounds = false
            cell2.commentUser2.clipsToBounds = true
            cell2.commentUser2.text = " "+self.addComment[indexPath.row]
            cell2.commentUser2.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell2.commentUser2.numberOfLines = 0
            
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImage[indexPath.row]
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell2.imageUser2.image = image
                cell2.imageUser2.contentMode = .ScaleAspectFill
                cell2.imageUser2.layer.borderWidth = 1.0
                cell2.imageUser2.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
                cell2.imageUser2.layer.masksToBounds = false
                cell2.imageUser2.layer.cornerRadius = 10
                cell2.imageUser2.clipsToBounds = true
            }
            
            return cell2
            
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func send(sender: AnyObject) {
        
        if self.messenger.text == "" {
            
        }else {
            
            let urlCommentOwner = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/sendCommentField.php"
            var parame:[String:String] = ["uid": self.uid1, "fid":fid, "detail":self.messenger.text!]
            Alamofire.request(.GET,urlCommentOwner,parameters: parame ,encoding: .URL).validate()
                .responseJSON{(response) in
                    
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
    
    @IBAction func back(sender: AnyObject) {
        timer.invalidate()
        self.performSegueWithIdentifier("back", sender: self)
        
    }
    
}

class commentCells: UITableViewCell {
    
    @IBOutlet weak var commentUser1: UILabel!
    @IBOutlet weak var imageUser1: UIImageView!
    
    
    
    @IBOutlet weak var commentUser2: UILabel!
    @IBOutlet weak var imageUser2: UIImageView!
    
    
}
