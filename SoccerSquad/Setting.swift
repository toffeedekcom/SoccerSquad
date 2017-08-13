//
//  Setting.swift
//  Project2
//
//  Created by toffee on 7/8/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class Setting: UITableViewController {


    @IBOutlet weak var customButoon: UIButton!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButoon.layer.cornerRadius = 14
        customButoon.layer.borderWidth = 1.0
        customButoon.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //logoutFacebook
    @IBAction func logoutAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Confirm!", message: "Ara you sure logout ?", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
            
            Activity().showLoading()
            if FBSDKAccessToken.currentAccessToken() != nil {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("login")
                
                Activity().hideLoading()
                self.performSegueWithIdentifier("unwindToMain", sender: self)
                
            }else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("login")
                Activity().hideLoading()
                self.performSegueWithIdentifier("unwindToMain", sender: self)
            }
            
        })
        
        let deleteAction = UIAlertAction(title: "CANCEl", style: .Destructive, handler: {(ACTION) in
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(deleteAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        alertController.view.layer.cornerRadius = 25
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
    
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
        
    }
     @IBAction func unwindToSettinf(segue: UIStoryboardSegue) {}

    // MARK: - Table view data source

   }
