//
//  editprofileTableViewController.swift
//  Project2
//
//  Created by CSmacmini on 6/21/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class editprofileTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var limitTextView: UILabel!
    
    @IBOutlet weak var customChangePhoto: UIButton!
    
    var uid = userId
    let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectOwner.php"
    let urlUpdate = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/updateOwner.php"
    
    var pickOption = ["Male" , "Female", "Other"]
    var ownerName = ""
    var ownerImage = ""
    var ownerEmail = ""
    var ownerStatus = ""
    var ownerMode = ""
    var ownerSex = ""
    var ownerTel = ""
    
    var limitLength = 0
    let limitLengthtextView = 100
    let imagePickerController = UIImagePickerController()
    
    @IBAction func changePhotoButton(sender: AnyObject) {
        
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
    @IBAction func saveData(sender: AnyObject) {
        
        if self.nameTextField.text == "" {
            MyAlerts("Please your put name!")
        }else {
            updateProfile()
            self.performSegueWithIdentifier("unwindToProfile", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        telTextField.delegate = self
        statusTextView.delegate = self
        imagePickerController.delegate = self
        navigationController?.delegate = self
        customPicker()

        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            
            getOwnerField()
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("Make sure your device is connected to the internet.")
            
            
        }

        
        
    }
    
    
    
    func getOwnerField() {
        
        var parameter:[String:String] = ["uid": uid]
        
        Alamofire.request(.GET,url ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.ownerName  = (value["uname"] as? String)!
                    self.ownerImage  = (value["uimage"] as? String)!
                    self.ownerMode = (value["udetail"] as? String)!
                    self.ownerStatus = (value["ustatus"] as? String)!
                    self.ownerSex = (value["usex"] as? String)!
                    self.ownerTel = (value["uphone"] as? String)!
                    
                }
                self.nameTextField.text = self.ownerName
                self.sexTextField.text = self.ownerSex
                self.statusTextView.text = self.ownerStatus
                self.telTextField.text = self.ownerTel
                
                var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.ownerImage
                
                if urlImage.isEmpty {
                    self.imageView.image = UIImage(named: "user")
                }else {
                    
                    self.downloadImage(urlImage) { (image) in
                        
                        if image == nil {
                            self.imageView.image = UIImage(named: "user")
                            
                        }else {
                            
                            self.imageView.image = image
                            self.imageView.contentMode = .ScaleAspectFill
                            self.imageView.layer.borderWidth = 1.0
                            self.imageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                            self.imageView.layer.masksToBounds = false
                            self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
                            self.imageView.clipsToBounds = true
                            
                        }
                    }
                    
                }
                
        }
        
    }

    func updateProfile() {
        
        Activity().showLoading()
        ownerName = self.nameTextField.text!
        ownerTel = self.telTextField.text!
        ownerSex = self.sexTextField.text!
        ownerStatus = self.statusTextView.text
        
        let parameter:[String:String] = ["uid": uid,"name": ownerName,"tel": ownerTel,"sex": ownerSex,"status": ownerStatus]
        
        Alamofire.upload(.POST, urlUpdate,headers: parameter ,multipartFormData: {multipartFormData in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageView.image!,0.4)! ,name: "file", fileName: self.ownerName+".JPEG", mimeType: "FieldManager/")
            
            
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
    //download image in database
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) {
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            //print(image)
            completion(image_Field)
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFill
            imageView.image = pickedImage
        }else if let pickerImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFill
            imageView.image = pickerImage
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newLength:Int = 0
        if textField == nameTextField {
            guard let text = nameTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 30
            
        }else if textField == telTextField {
            guard let text = telTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 10
        }else {
            print("Other TextField")
        }

        
        return newLength <= limitLength
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (statusTextView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars <= 100;
        
    }
    func checkRemainingChars() {
        
        let allowedChars = 100
        
        let charsInTextView = -statusTextView.text.characters.count
        
        let remainingChars = allowedChars + charsInTextView
        
        limitTextView.text = String(remainingChars)
        
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        checkRemainingChars()
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
        sexTextField.text = pickOption[row]
    }
    
    
    func donePressed(sender: UIBarButtonItem) {
        
        sexTextField.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        sexTextField.text = "Male"
        
        sexTextField.resignFirstResponder()
    }
    
    func customPicker() {
        
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
        self.imageView.clipsToBounds = true
        
        self.customChangePhoto.layer.cornerRadius = 10
        self.customChangePhoto.layer.borderWidth = 1.0
        self.customChangePhoto.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        sexTextField.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackOpaque
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(editprofileTableViewController.tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(editprofileTableViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        label.text = "Pick Sex type"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        sexTextField.inputAccessoryView = toolBar

        
    }

    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
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

