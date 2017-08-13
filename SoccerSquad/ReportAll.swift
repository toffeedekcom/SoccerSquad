//
//  ReportAll.swift
//  Project2
//
//  Created by toffee on 7/9/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class ReportAll: UITableViewController {
    
    
    var topic = ""
    var date = ""
    var rid = ""
    
    var addTopic = [String]()
    var addDate = [String]()
    var addRid = [String]()

    @IBAction func logout(sender: AnyObject) {
        let alertController = UIAlertController(title: "Confirm!", message: "Ara you sure logout ?", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("login")
            Activity().hideLoading()
            self.performSegueWithIdentifier("unwindToMain", sender: self)
            
            
        })
        
        let deleteAction = UIAlertAction(title: "CANCEl", style: .Destructive, handler: {(ACTION) in
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(deleteAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        alertController.view.layer.cornerRadius = 25

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.doReport()
    }
    
    func doReport(){
//        var parameter:[String:String] = [ "uid":userId]
        let urlReport = "https://nickgormanacademy.com/soccerSquat/admin/report/ReportAll.php"
        
        Alamofire.request(.GET,urlReport ,encoding: .URL).validate()
            .responseJSON{(response) in
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.topic  = (value["report_topic"] as? String)!
                        self.date  = (value["report_date"] as? String)!
                        self.rid = (value["report_id"] as? String)!
                      

                        self.addTopic.append(self.topic)
                        self.addDate.append(self.date)
                        self.addRid.append(self.rid)
                        
                        
                        
                        
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return addTopic.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rid = addRid[indexPath.row]
        performSegueWithIdentifier("detailreport", sender: self)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ReportAllCell
        
        cell.toPic.text = addTopic[indexPath.row]
        cell.date.text = addDate[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "detailreport") {
            let DestViewController = segue.destinationViewController as! DetailReport
            DestViewController.rid = self.rid
            
            
        }
    }
 

   
}
class ReportAllCell: UITableViewCell {
    
    @IBOutlet weak var toPic: UILabel!
    @IBOutlet weak var date: UILabel!
    
}
