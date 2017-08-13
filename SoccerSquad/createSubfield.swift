//
//  createSubfield.swift
//  Project2
//
//  Created by CSmacmini on 7/1/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire


class createSubfield: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    let imagePickerController = UIImagePickerController()
    var pickOption = ["Outdoor-turf" , "Indoor-turf", "Outdoor-artificial turf", "Indoor-artificial turf", "Outdoor-concrete", "Indoor-concrete", "Other"]
    let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/CreateSubField.php"
    var image = ""
    var type = ""
    var size = ""
    var id = global_fieldID
    
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBAction func ChangePhoto(sender: AnyObject) {
        
        self.imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Picture Profile", message: "Choose a mode", preferredStyle: .ActionSheet)
        
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
    
    @IBAction func Done(sender: AnyObject) {
        
        if self.typeTextField.text == "" {
            self.MyAlerts("Please your choose type sub field!")
        }else if self.sizeTextField.text == "" {
            self.MyAlerts("Please your enter size sub field!")
        }else {
            
            //Check connected network
            let net = NetworkReachabilityManager()
            net?.startListening()
            
            net?.listener = {status in
                
                if  net?.isReachable ?? false {
                    
                    if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                        self.CreateSubField()
                        self.performSegueWithIdentifier("unwindToFieldOption", sender: self)
                    }else if(net?.isReachableOnWWAN)! {
                        self.CreateSubField()
                        self.performSegueWithIdentifier("unwindToFieldOption", sender: self)
                    }else {
                        print("unknow")
                    }
                }
                else {
                    self.MyAlerts("No internet connnection")
                    print("no connection")
                }
                
            }
        }
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customize UI in tableview
        customIU()
        
        //self commend
        imagePickerController.delegate = self
        navigationController?.delegate = self
        
    }
    
    func customIU() {
        
        //Custom UI Image View
        self.ImageView.contentMode = .ScaleAspectFill
        self.ImageView.layer.borderWidth = 1.0
        self.ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
        self.ImageView.layer.masksToBounds = false
        self.ImageView.layer.cornerRadius = self.ImageView.frame.size.height/2
        self.ImageView.clipsToBounds = true
        
        //Custom UI Button
        self.customButton.layer.cornerRadius = 10
        self.customButton.layer.borderWidth = 1.0
        self.customButton.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
        
        //Custom type UI Picker
        let pickerView = UIPickerView()
        pickerView.delegate = self
        typeTextField.inputView = pickerView
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
        label.text = "Pick type"
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        typeTextField.inputAccessoryView = toolBar
        
    }
    
    //Alert Message Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageView.contentMode = .ScaleAspectFill
            ImageView.image = pickedImage
        }else if let pickerImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            ImageView.contentMode = .ScaleAspectFill
            ImageView.image = pickerImage
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
        typeTextField.text = pickOption[row]
    }
    
    
    func donePressed(sender: UIBarButtonItem) {
        
        typeTextField.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        typeTextField.text = "Outdoor-turf"
        
        typeTextField.resignFirstResponder()
    }
    
    func CreateSubField() {
        print(id)
        self.type = self.typeTextField.text!
        self.size = self.sizeTextField.text!
        let parameter:[String:String] = ["fid":id, "type": type, "size": size]
        Activity().showLoading()
        
        Alamofire.upload(.POST, url,headers: parameter ,multipartFormData: {multipartFormData in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.ImageView.image!,0.4)! ,name: "file", fileName: self.type+".JPEG", mimeType: "imageOwner/")
            
            
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
    
    
}
