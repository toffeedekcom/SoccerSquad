//
//  SearchUser.swift
//  Project2
//
//  Created by toffee on 7/7/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchUser: UITableViewController, UISearchResultsUpdating {
    
    
    var imagePlayer = ""
    var namePlayer = ""
    var uid = ""
    
    var name = "" //=ชื่อผู้เล่น เพื่อเอาไปเช็คในการsearch
    var chackName = [String]()//เอาไปหาจำนวน Index เพื่อเอาไปเช็คกับ uid
    
    var addImagePlayer = [String]()
    var addNamePlayer = [String]()
    var addUid = [String]()
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    var filteredAppleProducts = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.resultSearchController.searchBar.barTintColor = UIColor.whiteColor()
        self.resultSearchController.searchBar.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        self.tableView.reloadData()

       self.searchUser()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredAppleProducts.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.addNamePlayer as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredAppleProducts = array as! [String]
        self.tableView.reloadData()
        
    }

    
    func searchUser(){
        
        var parameter:[String:String] = [ "uid":userId]
        let urlPlayer = "https://nickgormanacademy.com/soccerSquat/comment/PlayerComment/SearchUser.php"
        
        Alamofire.request(.GET,urlPlayer ,parameters: parameter,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.imagePlayer  = (value["uimage"] as? String)!
                    self.namePlayer  = (value["uname"] as? String)!
                    self.uid  = (value["uid"] as? String)!
                    
                    self.addImagePlayer.append(self.imagePlayer)
                    self.addNamePlayer.append(self.namePlayer)
                    self.addUid.append(self.uid)
                }
                print(self.addNamePlayer)
                self.chackName = self.addNamePlayer
                self.tableView.reloadData()
                
                
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
        if self.resultSearchController.active {
           // addNamePlayer = filteredAppleProducts
            return self.filteredAppleProducts.count
            
        }
        else{
            
            return self.addNamePlayer.count
            
            
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SearchUserCell
        
        
        if self.resultSearchController.active {
           cell.nameUser.text = self.filteredAppleProducts[indexPath.row]
            cell.imageUser.hidden = true
            print("name1 \(self.filteredAppleProducts)")
            chackName = filteredAppleProducts
        }
        else {
            print("name \(addNamePlayer)")
            cell.imageUser.hidden = false
            chackName = addNamePlayer
            cell.nameUser.text = addNamePlayer[indexPath.row]
            var urlImage = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/" + addImagePlayer[indexPath.row]
            
            getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                cell.imageUser.image = image
                cell.imageUser.contentMode = .ScaleAspectFit
                cell.imageUser.layer.borderWidth = 1.0
                cell.imageUser.layer.masksToBounds = false
                cell.imageUser.layer.cornerRadius = cell.imageUser.frame.size.height/2
                cell.imageUser.clipsToBounds = true
            }

        }
        

        
        
        
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index:Int = addNamePlayer.indexOf(chackName[indexPath.row] )!
        print( index)
        print(chackName[indexPath.row] )

        self.uid = addUid[index]
        performSegueWithIdentifier("datauser", sender: self)
    }
    
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "datauser") {
            let DestViewController = segue.destinationViewController as! DataUserComment
            DestViewController.uid = self.uid
            
            
        }
    }


   
}

class SearchUserCell:UITableViewCell {
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
}
