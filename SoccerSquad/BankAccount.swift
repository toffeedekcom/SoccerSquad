//
//  BankAccount.swift
//  Project2
//
//  Created by toffee on 7/12/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class BankAccount: UITableViewController {
    
    var fid = ""
    
    var nameBank = ""
    var nameUser = ""
    var numberAccount = ""
    
    var addNameBank = [String]()
    var addNameUser = [String]()
    var addNumberAccount = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("fid = \(fid)")
        
       self.doBankAccount()
    }
    
    func doBankAccount() {
        
        
        let urlStatusBook = "https://nickgormanacademy.com/soccerSquat/booking/BankAccount.php"
        var parame:[String:String] = ["fid": self.fid]
        Alamofire.request(.GET,urlStatusBook,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.nameBank  = (value["bank_name"] as? String)!
                        self.nameUser  = (value["ac_name"] as? String)!
                        self.numberAccount = (value["ac_number"] as? String)!
                        
                        self.addNameBank.append(self.nameBank)
                        self.addNameUser.append(self.nameUser)
                        self.addNumberAccount.append(self.numberAccount)
                        
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
        return addNumberAccount.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BankAccountCell
        
        cell.nameBank.text = addNameBank[indexPath.row]
        cell.nameUser.text = addNameUser[indexPath.row]
         cell.numberAccount.text = addNumberAccount[indexPath.row]

        // Configure the cell...

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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

class BankAccountCell: UITableViewCell {
    
    @IBOutlet weak var nameBank: UILabel!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var numberAccount: UILabel!
    
    
    
}
