//
//  CommentTableViewController.swift
//  Project2
//
//  Created by toffee on 6/26/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {

    var num : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

         //var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(CommentTableViewController.update), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func update() {
//       print("number = \(String(num += 1))")
//        //self.num++
//    }

    // MARK: - Table view data source

    
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            performSegueWithIdentifier("player", sender: self)
        }
        else if(indexPath.section == 0 && indexPath.row == 1){
            performSegueWithIdentifier("owner", sender: self)
        }
        else if(indexPath.section == 1 && indexPath.row == 0){
            performSegueWithIdentifier("readplayer", sender: self)
           
        }

    }
    

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
