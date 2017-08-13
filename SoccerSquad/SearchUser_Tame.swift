//
//  SearchUser_Tame.swift
//  ParseDemo
//
//  Created by toffee on 11/7/2559 BE.
//  Copyright © 2559 abearablecode. All rights reserved.
//

import UIKit
import Alamofire

class SearchUser_Tame: UITableViewController, UISearchResultsUpdating {
    
    var filteredAppleProducts = [String]()
    var resultSearchController = UISearchController()
    
    var nn = ""
    var id = ""
    var getname = "" //ดึงข้อมูลจากtableview มาใช้
    var uid = ""
    var NameTeam:String = ""
    var idTeam:String = ""
    var chackName = [String]()
    
    
    
    
    
    let urlSring = "https://nickgormanacademy.com/soccerSquat/SreachUser.php"
    var data = [String]()
    var member = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("uid = \(uid)")
        var parameter:[String:String] = ["tid":idTeam, "uid":uid]
        
        Alamofire.request(.GET,urlSring ,parameters: parameter,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.nn  = (value["uname"] as? String)!
                    self.id  = (value["uid"] as? String)!
                    
                    self.data.append(self.nn)
                    self.member.append(self.id)
                }
                print("user>\(self.data)")
                self.resultSearchController = UISearchController(searchResultsController: nil)
                self.resultSearchController.searchResultsUpdater = self
                
                self.resultSearchController.dimsBackgroundDuringPresentation = false
                self.resultSearchController.searchBar.sizeToFit()
                self.tableView.tableHeaderView = self.resultSearchController.searchBar
                self.tableView.reloadData()
                
                
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.active {
            return self.filteredAppleProducts.count
        }
        else{
            
            return self.data.count
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        if self.resultSearchController.active {
            cell.textLabel?.text = self.filteredAppleProducts[indexPath.row]
            chackName = filteredAppleProducts
        }
        else {
            cell.showlable.text = self.data[indexPath.row]
            self.getname = self.data[indexPath.row]
            chackName = data
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index:Int = data.indexOf(chackName[indexPath.row] )!
        self.uid = member[index]
        
        let parame:[String:String] = ["uid": uid, "tid": idTeam]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/insert_invalit.php"
        
        Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                
        }
        performSegueWithIdentifier("datateam", sender: self)
        
    }
    
    //    func action(sender: UIButton) { //จะทำงานเมื่อกดปุ่ม invlit getid คือ idteam
    //        print("zzzzzz")
    //        self.uid = self.member[sender.tag]
    //            let parame:[String:String] = ["uid": uid, "tid": idTeam]
    //            let urlSring = "https://nickgormanacademy.com/soccerSquat/insert_invalit.php"
    //
    //            Alamofire.request(.GET,urlSring ,parameters: parame ,encoding: .URL).validate()
    //                    .responseJSON{(response) in
    //
    //
    //            }
    //        sender.enabled = false
    //
    //
    //    }
    
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredAppleProducts.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.data as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredAppleProducts = array as! [String]
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }

}
