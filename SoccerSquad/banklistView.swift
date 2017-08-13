//
//  banklistView.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/11/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class banklistView: UITableViewController {

    var fid = ""
    
    var getfid = ""
    var getbankid = ""
    var getbankname = ""
    var getbankowner = ""
    var getbanknumber = ""
    var id = ""
    
    
    var arrFID = [String]()
    var arrBID = [String]()
    var arrBNAME = [String]()
    var arrBOWNER = [String]()
    var arrBNUMBER = [String]()
    var indexPath = 0
    
    @IBAction func addAccount(sender: AnyObject) {
        
        // 1.
        var bankname_TextField: UITextField?
        var accountname_TextField: UITextField?
        var accountnumber_TextField: UITextField?
        
        
        // 2.
        let alertController = UIAlertController(
            title: "Create Bank Account",
            message: "Please enter your credentials",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // 3.
        let CreateAction = UIAlertAction(
        title: "Create", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            
            var bank_name = ""
            var account_name = ""
            var account_number = ""
            
            if bankname_TextField?.text == "" {
                return
            }else if accountname_TextField?.text == "" {
                return
            }else if accountnumber_TextField?.text == "" {
                return
            }else {
                bank_name = (bankname_TextField?.text)!
                account_name = (accountname_TextField?.text)!
                account_number = (accountnumber_TextField?.text)!
                
                let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/insertBank.php"
    
                let parameter:[String:String] = ["fid": self.fid, "namebank": bank_name, "ownername": account_name, "number": account_number]
                Activity().showLoading()
                Alamofire.request(.GET, URL, parameters: parameter ,encoding: .URL).validate()
                    .responseJSON{(response) in
                        print("Success")
                        Activity().hideLoading()
                        self.MyAlerts("Create Success")
                        self.selectAccount()
                }
                
            }
            
        }
        
        // 4.
        alertController.addTextFieldWithConfigurationHandler {
            (bank_name) -> Void in
            bankname_TextField = bank_name
            bankname_TextField!.placeholder = "Your bankname here"
        }
        
        alertController.addTextFieldWithConfigurationHandler {
            (account_name) -> Void in
            accountname_TextField = account_name
            accountname_TextField!.placeholder = "Your accountname here"
        }
        
        alertController.addTextFieldWithConfigurationHandler {
            (account_number) -> Void in
            accountnumber_TextField = account_number
            accountnumber_TextField?.keyboardType = .NumberPad
            accountnumber_TextField!.placeholder = "Your accountnumber here"
        }
        let Cancel =  UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        // 5.
        alertController.addAction(CreateAction)
        alertController.addAction(Cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        alertController.view.layer.cornerRadius = 25
      
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clearColor()
        self.refreshControl?.addTarget(self, action: #selector(banklistView.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        selectAccount()
    
    }

    
    func selectAccount() {
        self.arrFID = []
        self.arrBID = []
        self.arrBNAME = []
        self.arrBOWNER = []
        self.arrBNUMBER = []
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectBankAccount.php"
        var parameter:[String:String] = ["fid": fid]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.getfid = (value["fid"] as? String)!
                    self.getbankid = (value["bank_id"] as? String)!
                    self.getbankname = (value["bank_name"] as? String)!
                    self.getbankowner = (value["ac_name"] as? String)!
                    self.getbanknumber = (value["ac_number"] as? String)!
                    
                    self.arrFID.append(self.getfid)
                    self.arrBID.append(self.getbankid)
                    self.arrBNAME.append(self.getbankname)
                    self.arrBOWNER.append(self.getbankowner)
                    self.arrBNUMBER.append(self.getbanknumber)
                }
                
                self.tableView.reloadData()
        }

    }
    
    func removeAccount() {
        self.id = arrBID[self.indexPath]
        let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/removeBank.php"
        Activity().showLoading()
        var parameter:[String:String] = ["bank_id": id]
        
        Alamofire.request(.GET,URL ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                Activity().hideLoading()
                self.MyAlerts("Remove Success")
                self.selectAccount()
        }

    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        selectAccount()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func More() {
        let alert = UIAlertController(title: "More",message: "Choose your lists.",preferredStyle: .Alert)
        
        let action1 = UIAlertAction(title: "Edit Account", style: .Default, handler: { (action) -> Void in
            
            // 1.
            var bankname_TextField: UITextField?
            var accountname_TextField: UITextField?
            var accountnumber_TextField: UITextField?

            
            // 2.
            let alertController = UIAlertController(
                title: "Edit Bank Account",
                message: "Please enter your credentials",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // 3.
            let CreateAction = UIAlertAction(
            title: "Edit", style: UIAlertActionStyle.Default) {
                (action) -> Void in
                
                var bank_name = ""
                var account_name = ""
                var account_number = ""
                
                if bankname_TextField?.text == "" {
                    return
                }else if accountname_TextField?.text == "" {
                    return
                }else if accountnumber_TextField?.text == "" {
                    return
                }else {
                    bank_name = (bankname_TextField?.text)!
                    account_name = (accountname_TextField?.text)!
                    account_number = (accountnumber_TextField?.text)!
                    
                    print(bank_name)
                    
                    let URL = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/updateBank.php"
                    self.id = self.arrBID[self.indexPath]
                    
                    print(self.id)
                    
                    let parameter:[String:String] = ["bank_id": self.id, "namebank": bank_name, "ownername": account_name, "number": account_number]
                    Activity().showLoading()
                    Alamofire.request(.GET, URL, parameters: parameter ,encoding: .URL).validate()
                        .responseJSON{(response) in
                            print("Update Success")
                            Activity().hideLoading()
                            self.MyAlerts("Update Success")
                            self.selectAccount()
                    }
                    
                }
                
            }
            
            // 4.
            alertController.addTextFieldWithConfigurationHandler {
                (get_bank_name) -> Void in
                bankname_TextField = get_bank_name

            }
            
            alertController.addTextFieldWithConfigurationHandler {
                (get_acc_name) -> Void in
                accountname_TextField = get_acc_name

            }
            
            alertController.addTextFieldWithConfigurationHandler {
                (get_acc_number) -> Void in
                accountnumber_TextField = get_acc_number
                accountnumber_TextField?.keyboardType = .NumberPad

            }
            
            let Cancel =  UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
            // 5.
            alertController.addAction(CreateAction)
            alertController.addAction(Cancel)
            self.presentViewController(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
            alertController.view.layer.cornerRadius = 25

            
        })
        
        let action2 = UIAlertAction(title: "Remove Account", style: .Default, handler: { (action) -> Void in
            
            let alertController = UIAlertController(title: "Confirm!", message: "Ara you sure remove bank account ?", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(ACTION) in

                self.removeAccount()
            })
            
            let deleteAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: {(ACTION) in
            })
            
            alertController.addAction(okAction)
            alertController.addAction(deleteAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
            alertController.view.layer.cornerRadius = 25
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action) -> Void in })
        
        // Add action buttons and present the Alert
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
        // Restyle the view of the Alert
        alert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0) // change text color of the buttons
        
        alert.view.layer.cornerRadius = 25   // change corner radius

        
    }
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.indexPath = indexPath.row
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrBID.count
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bankCell", forIndexPath: indexPath) as! bankUIcell
        
        cell.bankname.text = arrBNAME[indexPath.row]
        cell.ownername.text = arrBOWNER[indexPath.row]
        cell.accnumber.text = arrBNUMBER[indexPath.row]
        
        cell.tapAction = { [weak self] (cell) in
            
            print(self!.arrBID[indexPath.row])
            self?.More()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
}

class bankUIcell: UITableViewCell {
    var tapAction: ((UITableViewCell) -> Void)?
    @IBOutlet weak var bankname: UILabel!
    @IBOutlet weak var ownername: UILabel!
    @IBOutlet weak var accnumber: UILabel!
    @IBAction func moreAction(sender: AnyObject) {
        tapAction?(self)
    }
}