//
//  reportView.swift
//  Project2
//
//  Created by Jay on 7/6/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class reportView: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var imagePickerController = UIImagePickerController()
    var imagefile:UIImage?
    var pickOption = ["User has committed an offense", "The application has a problem", "Other"]
    var uid = userId
    var topicVar = ""
    var detailVar = ""
    var dateVar = ""
    
    

    @IBOutlet weak var topic: UITextField!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var customButton: UIButton!
    
    @IBAction func ChooseImage(sender: AnyObject) {
        PickerImage()
        
    }
    @IBAction func Sendreport(sender: AnyObject) {
        
        if self.topic.text == "" {
            MyAlerts("Please your put topic!")
            
        }else if self.detail.text == ""{
            MyAlerts("Please your put detail!")
            
        }else if self.date.text == "" {
            MyAlerts("Please your put date!")
            
        }else if self.imagefile == nil {
            MyAlerts("Please your put photo!")
            
        }else {
            report()
            self.MyAlerts("Send Report Success")
            self.performSegueWithIdentifier("unwindToOption", sender: self)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomUI()
        
        tableView.allowsSelection = false
        
    }
    
    func report() {
        Activity().showLoading()
        self.topicVar = self.topic.text!
        self.detailVar = self.detail.text!
        self.dateVar = self.date.text!
        let parameter:[String:String] = ["uid":uid, "topic": topicVar, "detail": detailVar, "date": dateVar]
        let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/insertReport.php"
        
        
        Alamofire.upload(.POST, url,headers: parameter ,multipartFormData: {multipartFormData in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imagefile!,0.4)! ,name: "file", fileName: self.topicVar+".JPEG", mimeType: "imageOwner/")
            
            
            for (key, value) in parameter {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
            }
            
            } ,  encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { (response) in
                        
                        Activity().hideLoading()
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
                
        })
        
        
    }

    
    //Functions
    func CustomUI() {
        customButton.layer.cornerRadius = 14
        customButton.layer.borderWidth = 1.0
        customButton.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
        //Custom type UI Picker
        let pickerView = UIPickerView()
        pickerView.delegate = self
        topic.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackOpaque
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(createSubfield.tappedToolBarBtn))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(createSubfield.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        label.text = "Topic pick type"
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        topic.inputAccessoryView = toolBar

    }
    
    func PickerImage() {
        self.imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo", message: "Choose a mode", preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                self.imagePickerController.sourceType = .Camera
                self.presentViewController(self.imagePickerController, animated: true, completion: nil)
            }else {
                
                print("Camera not available")
                
            }
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (action: UIAlertAction) in
            
            self.imagePickerController.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePickerController, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil ))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            imagefile = pickedImage
            print(imagefile)
            
        }else if let pickerImage = info[UIImagePickerControllerEditedImage] as? UIImage {

            imagefile = pickerImage
            print(imagefile)
        }
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickOption[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        topic.text = pickOption[row]
    }
    
    
    func donePressed(sender: UIBarButtonItem) {
        
        topic.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        topic.text = "User has committed an offense"
        
        topic.resignFirstResponder()
    }
    
    //Alert Message Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

}
