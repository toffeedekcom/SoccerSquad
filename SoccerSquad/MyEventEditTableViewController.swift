//
//  MyEventEditTableViewController.swift
//  Project2
//
//  Created by toffee on 6/24/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class MyEventEditTableViewController: UITableViewController, UIPickerViewDelegate {
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var detail: UITextView!
    
    var playerId = ""
    var fid = ""

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectlocation" {
            (segue.destinationViewController as! EditLocationTableViewController).delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.doPullEvent()
    }
    
    @IBAction func pickerDateTime(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(MyEventEditTableViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        date.resignFirstResponder()
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var strDate = dateFormatter.stringFromDate(sender.date)
        date.text = strDate + ""
        print(strDate + "")
        
    }
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        date.resignFirstResponder()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 1 && indexPath.row == 1){
            performSegueWithIdentifier("selectlocation", sender: self)
        }
    }
    
    func doPullEvent() {
        var urlMyEvent = "https://nickgormanacademy.com/soccerSquat/event/MyEvent.php"
        var parameter:[String:String] = [ "pid":playerId]
        
        Alamofire.request(.GET,urlMyEvent ,parameters: parameter, encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                
                for value in JSON {
                    
                    self.name.text  = (value["playername"] as? String)!
                   
                    self.detail.text  = (value["playerdetail"] as? String)!
                    self.date.text = (value["playerdate"] as? String)!
                    self.location.text = (value["fname"] as? String)!
                    self.fid = (value["fid"] as? String)!
                    
                }
                
                
        }

    }
    
    
    @IBAction func saveEvent(sender: AnyObject) {
        
        print("date = \(date.text!)")
         var urlMyEvent = "https://nickgormanacademy.com/soccerSquat/event/UpdateEvent.php"
        var parameter:[String:String] = [ "pid":playerId,"name":self.name.text!,"detail":self.detail.text,"date":date.text!,"location":self.location.text!,"fid":self.fid]
        
        Alamofire.request(.GET,urlMyEvent ,parameters: parameter, encoding: .URL).validate()
            .responseJSON{(response) in
               
                
                
        }

        
        
    }

 

}

extension MyEventEditTableViewController: getplace {
    func getplaceID(id: String) {
        self.fid = id
    }
    
    func getplaceName(name: String) {
        self.location.text = name
    }
}
