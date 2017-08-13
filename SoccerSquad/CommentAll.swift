//
//  CommentAll.swift
//  Project2
//
//  Created by toffee on 7/9/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class CommentAll: UITableViewController {
    
    var comment = ""
    var date = ""
    var uid = ""
    
    var addComment = [String]()
    var addDate = [String]()
    var addUid = [String]()
    
   
    let urlSring = "https://nickgormanacademy.com/soccerSquat/admin/comment/CommentAll.php"
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doCommentAll()
        
    }
    
    func doCommentAll(){
    
        var parame:[String:String] = [ "segmemt":"0"]
        
        Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.uid  = (value["uid2"] as? String)!
                        self.comment  = (value["cuserdetail"] as? String)!
                        self.date = (value["cuserdate"] as? String)!
                        
                        self.addUid.append(self.uid)
                        self.addComment.append(self.comment)
                        self.addDate.append(self.date)
                        
                    }
                    print(self.addComment)
                    self.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }
    
    }
    
    @IBAction func segment(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            addComment = []
            addDate = []
            addUid = []
            var parame:[String:String] = [ "segmemt":"0"]
           
            Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
                .responseJSON{(response) in
                    
                        switch response.result {
                        case .Success:
                            
                            var JSON = [AnyObject]()
                            JSON = response.result.value as! [AnyObject]!
                            for value in JSON {
                                
                                self.uid  = (value["uid2"] as? String)!
                                self.comment  = (value["cuserdetail"] as? String)!
                                self.date = (value["cuserdate"] as? String)!
                                
                                self.addUid.append(self.uid)
                                self.addComment.append(self.comment)
                                self.addDate.append(self.date)
                                
                            }
                            self.tableView.reloadData()
                        case .Failure(let error):
                            print(error)
                        }
                        
                    
                    
            }
            print("First")
        case 1:
            
            addComment = []
            addDate = []
            addUid = []
            var parame1:[String:String] = ["segmemt":"1"]
           
            Alamofire.request(.GET,urlSring ,parameters: parame1 ,encoding: .URL).validate()
                .responseJSON{(response) in
                    switch response.result {
                    case .Success:
                        
                        var JSON = [AnyObject]()
                        JSON = response.result.value as! [AnyObject]!
                        for value in JSON {
                            
                            self.uid  = (value["uid"] as? String)!
                            self.comment  = (value["cfielddetail"] as? String)!
                            self.date = (value["cfielddate"] as? String)!
                            
                            self.addUid.append(self.uid)
                            self.addComment.append(self.comment)
                            self.addDate.append(self.date)
                            
                        }
                        self.tableView.reloadData()
                    case .Failure(let error):
                        print(error)
                    }
                    
            }
            
        default:
            break;
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
        return addComment.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CommentAllCell
        
        cell.detail.text = addComment[indexPath.row]
        cell.date.text = addDate[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.uid = addUid[indexPath.row]
        performSegueWithIdentifier("block", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "block") {
            let DestViewController = segue.destinationViewController as! Block
            DestViewController.uid = self.uid
            
            
        }
    }
 

}

class CommentAllCell: UITableViewCell {
    
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
}
