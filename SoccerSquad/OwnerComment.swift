//
//  OwnerComment.swift
//  Project2
//
//  Created by toffee on 7/5/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage



class OwnerComment:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var fid = ""
    var num :Int = 0
    
    var comment = ""
    var image = ""
    var uid = ""
    var userid = ""
    var sum = 10
    var imageField = ""
    
    var addComment = [String]()
    var addImage = [String]()
    var addUid = [String]()
    var addImageField = [String]()
    var timer  = NSTimer()
    
    
    @IBOutlet weak var messanger: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToButton: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addComment = []
        self.addImage = []
        self.addUid = []
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.doMessenger()

         timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(OwnerComment.update), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
           print("number = \(num)")
        // self.tableView.reloadData()
        
        if(num == sum){
            self.doMessenger()
            sum = sum+10
        
        }
            self.num++
    }
    
    func doMessenger(){
        self.addComment = []
        self.addImage = []
        self.addUid = []
        
        //tableView.scrollToRowAtIndexPath(, atScrollPosition: <#T##UITableViewScrollPosition#>, animated: <#T##Bool#>)
        
        //tableView.scrollToRowAtIndexPath(bottomIndexPath, atScrollPosition: .Bottom,animated: true)
               
        let urlCommentOwner = "https://nickgormanacademy.com/soccerSquat/comment/OwnerComment/RequestComment.php"
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
                        self.uid = (value["uid"] as? String)!
                        self.imageField = (value["fimage"] as? String)!
                        
                        self.addComment.append(self.comment)
                        self.addImage.append(self.image)
                        self.addUid.append(self.uid)
                        self.addImageField.append(self.imageField)

                        
                        
                    }
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
        return self.addComment.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if (self.userid == addUid[indexPath.row]) {
                let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! OwnerCommentCell
           
                cell2.viewOwner.layer.cornerRadius = 12
                cell2.messengerMe.text = self.addComment[indexPath.row]
                cell2.messengerMe.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
                cell2.messengerMe.numberOfLines = 0

           
                var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + addImageField[indexPath.row]
                getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                    cell2.imageOwner.image = image
                    cell2.imageOwner.contentMode = .ScaleAspectFit
                    cell2.imageOwner.layer.borderWidth = 1.0
                    cell2.imageOwner.layer.masksToBounds = false
                    cell2.imageOwner.layer.cornerRadius = cell2.imageOwner.frame.size.height/2
                    cell2.imageOwner.clipsToBounds = true
                }

            return cell2
        }
        else{
                let cell1 = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! OwnerCommentCell
           cell1.viewUser.layer.cornerRadius = 12
            cell1.messengerYou.text = self.addComment[indexPath.row]
            cell1.messengerYou.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell1.messengerYou.numberOfLines = 0
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImage[indexPath.row]
                getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                    cell1.imageUser.image = image
                    cell1.imageUser.contentMode = .ScaleAspectFit
                    cell1.imageUser.layer.borderWidth = 1.0
                    cell1.imageUser.layer.masksToBounds = false
                    cell1.imageUser.layer.cornerRadius = cell1.imageUser.frame.size.height/2
                    cell1.imageUser.clipsToBounds = true
                }

            return cell1
        }
    }
    
    func updateTableContentInset() {
        let numRows = tableView(tableView, numberOfRowsInSection: 0)
        var contentInsetTop = tableView.bounds.size.height
        for i in 0..<numRows {
            contentInsetTop -= tableView(tableView, heightForRowAtIndexPath: NSIndexPath(forItem: i, inSection: 0))
            if contentInsetTop <= 0 {
                contentInsetTop = 0
            }
        }
        tableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0)
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
        
        print("xxxxxxxxx")
        let urlCommentOwner = "https://nickgormanacademy.com/soccerSquat/comment/OwnerComment/SendMessenger.php"
        var parame:[String:String] = ["fid": self.fid, "uid":userId, "detail":self.messanger.text!]
        Alamofire.request(.GET,urlCommentOwner,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
        
        }
       

        
        
    }
    
    @IBAction func back(sender: AnyObject) {
        
         timer.invalidate()
        //self.performSegue(withIdentifier: "comment", sender: self)
        
        self.performSegueWithIdentifier("comment", sender: self)
    }
    
    
   // @IBOutlet weak var constraintToButton: NSLayoutConstraint?
//    
//    func showOrHideKey(notification:NSNotification){
//        if let keyboardInfo:Dictionary = notification.userInfo{
//            if notification.name == UIKeyboardWillShowNotification {
//                UIView.animateWithDuration(1, animations: { ()in
//                    self.constraintToButton?.constant = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
//                    self.view.layoutIfNeeded()
//                
//                }){(completed:Bool) -> Void in
//                    self.moveToLastMessange()
//                
//                }
//            }
//            else if notification.name == UIKeyboardWillShowNotification{
//            
//                UIView.animateWithDuration(1, animations: {() in
//                    self.constraintToButton?.constant = 0
//                    self.view.layoutIfNeeded()
//                
//                }){(completed:Bool) -> Void in
//                     self.moveToLastMessange()
//                }
//            }
//        
//        }
//    }
//    
//    func moveToLastMessange(){
//        if self.tableView.contentSize.height > CGRectGetHeight(self.tableView.frame) {
//            
//            let contentOfSet = CGPointMake(0 , self.tableView.contentSize.height - CGRectGetHeight(self.tableView.frame))
//            self.tableView.setContentOffset(contentOfSet, animated: true)
//        }
//    
//    }
    
   
}
