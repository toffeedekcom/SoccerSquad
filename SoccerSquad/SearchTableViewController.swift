//
//  SearchTableViewController.swift
//  Soccer Squad
//
//  Created by Jay on 5/30/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit
import Alamofire

class SearchTableViewController: UITableViewController, UISearchResultsUpdating{
    
    var imagePlayer = ""
    var namePlayer = ""
    var uid = ""
    var mode = ""
    
    var name = "" //=ชื่อผู้เล่น เพื่อเอาไปเช็คในการsearch
    var chackName = [String]()//เอาไปหาจำนวน Index เพื่อเอาไปเช็คกับ uid
    
    var addImagePlayer = [String]()
    var addNamePlayer = [String]()
    var addUid = [String]()
    var addmode = [String]()
    
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    //    var resultController = UITableViewController()
    
    var filteredAppleProducts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        self.tableView.separatorColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.resultSearchController.searchBar.barTintColor = UIColor.whiteColor()
        self.resultSearchController.searchBar.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.refreshControl?.addTarget(self, action: #selector(SearchTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.separatorColor = UIColor.clearColor()
        self.searchUser()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        
        searchUser()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        self.filteredAppleProducts.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.addNamePlayer as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredAppleProducts = array as! [String]
        self.tableView.reloadData()
    }
    
    func searchUser(){
        Activity().showLoading()
        self.addImagePlayer = []
        self.addNamePlayer = []
        self.addUid = []
        
        var parameter:[String:String] = [ "uid":userId]
        let urlPlayer = "https://nickgormanacademy.com/soccerSquat/comment/PlayerComment/SearchUser.php"
        
        Alamofire.request(.GET,urlPlayer ,parameters: parameter,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                if response.result.value == nil {
                    print("Not found data")
                }else {
                    
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.imagePlayer  = (value["uimage"] as? String)!
                        self.namePlayer  = (value["uname"] as? String)!
                        self.uid  = (value["uid"] as? String)!
                        self.mode = (value["udetail"] as? String)!
                        
                        self.addImagePlayer.append(self.imagePlayer)
                        self.addNamePlayer.append(self.namePlayer)
                        self.addUid.append(self.uid)
                        self.addmode.append(self.mode)
                    }
                    self.chackName = self.addNamePlayer
                    self.tableView.reloadData()
                }
                
        }
        Activity().hideLoading()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.active {
            
            return self.filteredAppleProducts.count
            
        }
        else{
            
            return self.addNamePlayer.count
            
            
        }
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCellplayer", forIndexPath: indexPath) as! ownerSearchCell
        
        if self.resultSearchController.active {
            cell.nameUser.text = self.filteredAppleProducts[indexPath.row]
            cell.imageUser.hidden = true
            cell.mode.hidden = true
            chackName = filteredAppleProducts
        }
        else {
            cell.imageUser.hidden = false
            chackName = addNamePlayer
            cell.nameUser.text = addNamePlayer[indexPath.row]
            cell.mode.text = addmode[indexPath.row]
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImagePlayer[indexPath.row]
            
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell.imageUser.image = image
                cell.imageUser.contentMode = .ScaleAspectFill
                cell.imageUser.layer.borderWidth = 1.0
                cell.imageUser.layer.masksToBounds = false
                cell.imageUser.layer.cornerRadius = cell.imageUser.frame.size.height/2
                cell.imageUser.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
                cell.imageUser.clipsToBounds = true
            }
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
        
        let index:Int = addNamePlayer.indexOf(chackName[indexPath.row] )!
        
        self.uid = addUid[index]
        performSegueWithIdentifier("showplayer", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showplayer") {
            let destination = segue.destinationViewController as! NEW_profile
            destination.uid = self.uid
            
        }
    }

    
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    
}

class ownerSearchCell:UITableViewCell {
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var mode: UILabel!
    
}

