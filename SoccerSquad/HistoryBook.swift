//
//  HistoryBook.swift
//  Project2
//
//  Created by toffee on 7/3/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class HistoryBook: UITableViewController {
    
    
    var nameField = ""
    var startTime = ""
    var stopTime = ""
    var date = ""
    var status = ""
    var bookId = ""
    var fid = ""
    
    
    var addNameField = [String]()
    var addStartTime = [String]()
    var addStopTime = [String]()
    var addDate = [String]()
    var addStatus = [String]()
    var addBookId = [String]()
    var addFid = [String]()
    
    
   // var refresh = UIRefreshControl()
    //var dateFormatter = NSDateFormatter()
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doHistory()
    }
    
    
    func doHistory() {
        
        tableView.reloadData()
        self.addNameField = []
        self.addStartTime = []
        self.addStopTime = []
        self.addDate = []
        self.addStatus = []
        self.addBookId = []
        //btn.hidden = true
        
        let urlHistoryAll = "https://nickgormanacademy.com/soccerSquat/booking/HistoryBook.php"
        var parame:[String:String] = ["uid": userId]
        Alamofire.request(.GET,urlHistoryAll,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.nameField  = (value["fname"] as? String)!
                        self.startTime  = (value["bstartime"] as? String)!
                        self.stopTime = (value["bstoptime"] as? String)!
                        self.date = (value["bdate"] as? String)!
                        self.status = (value["bstatus"] as? String)!
                        self.bookId = (value["bookid"] as? String)!
                        self.fid = (value["fid"] as? String)!

                        self.addNameField.append(self.nameField)
                        self.addStartTime.append(self.startTime)
                        self.addStopTime.append(self.stopTime)
                        self.addDate.append(self.date)
                        self.addStatus.append(self.status)
                        self.addBookId.append(self.bookId)
                        self.addFid.append(self.fid)
                        
                    }
                self.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                
        }
//        let now = NSDate()
//        
//        let updateString = "Refresh... " + self.dateFormatter.stringFromDate(now)
//        self.refresh.attributedTitle = NSAttributedString(string: updateString)
//        self.refresh.addTarget(self, action: #selector(self.doHistory), forControlEvents: UIControlEvents.ValueChanged)
//        self.refresh.endRefreshing()
//        self.tableView.addSubview(self.refresh)
//        self.tableView.reloadData()
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
        return self.addNameField.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HistoryBookCell
        
        var btn: UIButton = UIButton(frame: CGRectMake(150, 70, 30, 30))
        cell.nameField.text = self.addNameField[indexPath.row]
        cell.startTime.text = self.addStartTime[indexPath.row]
        cell.stopTime.text = self.addStopTime[indexPath.row]
        cell.date.text = self.addDate[indexPath.row]
        
        if(self.addStatus[indexPath.row] == "Waiting"){
            print("waiting")
            cell.status.text = self.addStatus[indexPath.row]
            cell.status.textColor = UIColor.redColor()
            btn.setImage(UIImage(named: "icon_cancel"), forState: UIControlState.Normal)
            btn.tag = indexPath.row
            btn.addTarget(self, action: "cancelBook:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(btn)
            
        }
        else if(self.addStatus[indexPath.row] == "Success" || self.addStatus[indexPath.row] == "Confirm"){
            
            print("seccess")
            cell.status.text = self.addStatus[indexPath.row]
            cell.status.textColor = UIColor.greenColor()
            
        }
        
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.addStatus[indexPath.row] == "Waiting"){
           
            self.bookId = self.addBookId[indexPath.row]
            self.fid = self.addFid[indexPath.row]
            print(self.bookId)
            performSegueWithIdentifier("paywaiting", sender: self)
        
        }
        else if(self.addStatus[indexPath.row] == "Success" || self.addStatus[indexPath.row] == "Confirm"){
           
            self.bookId = self.addBookId[indexPath.row]
            print(self.bookId)
            performSegueWithIdentifier("payseccess", sender: self)
        
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "paywaiting") {
            let DestViewController = segue.destinationViewController as! PayWaiting
            DestViewController.bookId = self.bookId
            DestViewController.fid = self.fid
            
            
            
        }
        else if(segue.identifier == "payseccess"){
            let DestViewController = segue.destinationViewController as! PaySeccess
            DestViewController.bookId = self.bookId
        
        }
    }
    
    func cancelBook(sender: UIButton) {
        
        self.bookId = self.addBookId[sender.tag]
        
        let urlCancelBook = "https://nickgormanacademy.com/soccerSquat/booking/CancelBook.php"
        var parame:[String:String] = ["bookId": self.bookId]
        Alamofire.request(.GET,urlCancelBook,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
        }
        self.doHistory()
    
    
    }

 

   
}
