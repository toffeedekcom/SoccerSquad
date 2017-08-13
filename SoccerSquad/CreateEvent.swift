//
//  CreateEvent.swift
//  Project2
//
//  Created by toffee on 6/20/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire


class CreateEvent: UITableViewController, UIPickerViewDelegate{
    
//    UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
    
    
    
    var fid = ""
    var nameField = ""
    
    var tid = ""
    var nameMyTeam = ""
    
    var setDetail = ""
    var setNameEvent = ""
    var dateEvent = ""
    var setnameEvent = ""
    
    
    @IBOutlet weak var nameEvent: UITextField!
    @IBOutlet weak var setDateTime: UITextField!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var nameTeam: UILabel!
    @IBOutlet weak var amouat: UITextField!
    
  
    @IBOutlet weak var detail: UITextField!
    
    @IBAction func dateTimePicker(sender: UITextField) {
        print("aa")
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CreateEvent.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        setDateTime.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackOpaque
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateEvent.tappedToolBarBtn))
        
        //let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(CreateFieldTableViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
        label.text = "Pick Field type"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
       // toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        setDateTime.inputAccessoryView = toolBar
        
        //self.navigationItem.setHidesBackButton(true, animated:true)
        
        
        
        if(self.fid != ""){
            self.location.text = nameField
            self.nameTeam.text = nameMyTeam
            self.setDateTime.text = dateEvent
            self.nameEvent.text = setNameEvent
            self.detail.text = setDetail
            print("fid = \(fid)")
            print("tid = \(tid)")

            

        }
        if (self.tid != "") {
           // self.nameTeam.text = nameMyTeam
            
            self.location.text = nameField
            self.nameTeam.text = nameMyTeam
            self.setDateTime.text = dateEvent
            self.nameEvent.text = setNameEvent
            self.detail.text = setDetail
            
            print("fid = \(fid)")
            print("tid = \(tid)")

            

        }
        
        

        
    }
    
    


    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        setDateTime.resignFirstResponder()
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var strDate = dateFormatter.stringFromDate(sender.date)
        setDateTime.text = strDate + ""
        
    }
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        setDateTime.resignFirstResponder()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //print("index = \([indexPath.section] )")
        if (indexPath.section == 0 && indexPath.row == 0) {
            print("section = \([indexPath.section] )")
            print("index = \([indexPath.row] )")
        }
        else if(indexPath.section == 1 && indexPath.row == 0){
            print("section1 = \([indexPath.section] )")
            print("index1 = \([indexPath.row] )")
        }
        else if(indexPath.section == 1 && indexPath.row == 1){
            performSegueWithIdentifier("myteam", sender: self)
        }
        else if(indexPath.section == 1 && indexPath.row == 2){
             performSegueWithIdentifier("location", sender: self)
           
        }
        else if(indexPath.section == 1 && indexPath.row == 3){
            print("section4 = \([indexPath.section] )")
            print("index4 = \([indexPath.row] )")
        }
        
    
        
        
        

        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "tabbar") {
            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("event")
                                self.presentViewController(viewController, animated: true, completion: nil)
                            })

            
        }
        else if(segue.identifier == "location"){
            
//            let navController = segue.destinationViewController as! UINavigationController
//            let DestViewController = navController.topViewController as! EventLocationTableViewController
            let DestViewController = segue.destinationViewController as! EventLocationTableViewController
            
                DestViewController.tid = tid
                DestViewController.nameTeam = nameTeam.text!
                DestViewController.detail = detail.text!
                DestViewController.nameEvent = nameEvent.text!
                DestViewController.date = setDateTime.text!
          
            
        
        }
        else if(segue.identifier == "myteam"){
            let DestViewController = segue.destinationViewController as! SelectTeam
            DestViewController.fid = fid
            DestViewController.nameField = location.text!
            DestViewController.detail = detail.text!
            DestViewController.nameEvent = nameEvent.text!
            DestViewController.date = setDateTime.text!
            
            
        }

        
   }
    
    @IBAction func doSave(sender: AnyObject) {
        
        if (nameEvent.text == "") {
            var alert = UIAlertView(title: "Error", message: "Please Enter a NameEvent. ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else if (setDateTime.text == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter a DateTime. ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        
        }
        else if(tid == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter a Team ", delegate: self, cancelButtonTitle: "OK")
            alert.show()

        }
        else if(fid == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter a Field ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else if(detail.text == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter a Detail ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else if(amouat.text == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter a amouat ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else{
            
            let urlFieldAll = "https://nickgormanacademy.com/soccerSquat/event/SaveEvent.php"
            var parame:[String:String] = ["nameEvent": nameEvent.text!, "detailEvent":detail.text!, "date":setDateTime.text!, "tid":tid, "fid":fid,"amount":amouat.text!]

            Alamofire.request(.GET,urlFieldAll, parameters: parame ,encoding: .URL).validate()
                .responseJSON{(response) in
                    
                        
                    }
            var alert = UIAlertView(title: "Succes", message: "Save succeed ", delegate: self, cancelButtonTitle: "OK")
            alert.show()

                    
            }
        
        }
    
    
    @IBAction func cancel(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    @IBAction func unwindToEventLocation(segue: UIStoryboardSegue) {
        print("update")
        self.viewDidLoad()
        
    }

    
    
    
}








