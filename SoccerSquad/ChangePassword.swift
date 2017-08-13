//
//  ChangePassword.swift
//  SoccerSquad
//
//  Created by toffee on 7/23/2560 BE.
//  Copyright © 2560 Project. All rights reserved.
//

import UIKit
import Alamofire

class ChangePassword: UITableViewController {
    
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var btn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 12
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changePassword(sender: AnyObject) {
        
        
        
        let url = "https://nickgormanacademy.com/soccerSquat/user/ChackChangePassword.php"
        var parame:[String:String] = ["uid":userId,"password": password.text!]
        Alamofire.request(.GET,url,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        if((value["chackpassword"]as? String)! == "0"){
                        
                            var alert = UIAlertView(title: "alert", message: "Please enter the OLD PASSWORD.", delegate: self, cancelButtonTitle: "OK")
                            alert.show()

                        }else{
                            print("22")
                            if(self.newPassword.text != self.confirmPassword.text){
                                var alert = UIAlertView(title: "alert", message: "NewPassword And ConfirmPassword No Macth.", delegate: self, cancelButtonTitle: "OK")
                                alert.show()

                            
                            }else{
                                
                                
                                let alertController = UIAlertController(title: "Confirm!", message: "Do You Want ChangePassword", preferredStyle: .Alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in
                                    
                                    let urlChangePassword = "https://nickgormanacademy.com/soccerSquat/user/ChangePassword.php"
                                    var parame:[String:String] = ["uid":userId , "password": self.newPassword.text!]
                                    Alamofire.request(.GET,urlChangePassword,parameters: parame,encoding: .URL).validate()
                                        .responseJSON{(response) in
                                            
                                    }
                                   
                                    NSUserDefaults.standardUserDefaults().removeObjectForKey("login")
                                    Activity().hideLoading()
                                    self.performSegueWithIdentifier("unwindToLogInScreen", sender: self)
                                    
                                    
                                })
                                
                                let deleteAction = UIAlertAction(title: "CANCEl", style: .Destructive, handler: {(ACTION) in
                                    
                                })
                                
                                alertController.addAction(okAction)
                                alertController.addAction(deleteAction)
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                                alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
                                alertController.view.layer.cornerRadius = 25
                            
                            }
                        
                        }
                        
                        
                    }
                    self.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                
        }

        
    }

    // MARK: - Table view data source

   
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
