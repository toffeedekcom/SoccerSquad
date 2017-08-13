//
//  costomOptionProfile.swift
//  Project2
//
//  Created by CSmacmini on 6/21/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class costomOptionProfile: UITableViewController {
    
    var uid = ""
    var email = ""
    var pass = ""
    
    
    
    @IBOutlet weak var customButton: UIButton!
    @IBAction func Logout(sender: AnyObject) {
        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "changeEmail" {
            let desVC = segue.destinationViewController as! changeEmailView
            desVC.uidEmail = self.uid
            desVC.chEmail = self.email
        }else if segue.identifier == "changePass" {
            let desVC = segue.destinationViewController as! ChangePasswordView
            desVC.uidPass = self.uid
            desVC.chPass = self.pass
        }
    }
    
    @IBAction func unwindToOption(segue: UIStoryboardSegue) {
        print("back..")
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customUI()
    }
    
    func customUI() {
    
        customButton.layer.cornerRadius = 14
        customButton.layer.borderWidth = 1.0
        customButton.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }


}
