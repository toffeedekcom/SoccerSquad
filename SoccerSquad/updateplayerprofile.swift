//
//  updateplayerprofile.swift
//  Soccer Squad
//
//  Created by CSmacmini on 7/16/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class updateplayerprofile: UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var brithDay: UITextField!
    
    var player_id = ""
    var player_name = ""
    var player_position = ""
    var player_gender = ""
    var player_tel = ""
    var player_status = ""
    var player_image = ""
    var player_birthday = ""
    
    let imagePickerController = UIImagePickerController()
    var limitLength = 0
    let limitLengthtextView = 100
    
    var pickOption = ["Male" , "Female", "Other"]
    var PositionOption = ["Forward" , "Left midfield", "Right midfield", "Midfield", "Left-back", "Right-back", "Centre-back", "Goalkeeper"]
    let datePickerView:UIDatePicker = UIDatePicker()
    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.btn.layer.cornerRadius = 12
        imagePickerController.delegate = self
        navigationController?.delegate = self
        name.delegate = self
        phone.delegate = self
        statusTextView.delegate = self
        sex.delegate = self
        position.delegate = self
        brithDay.delegate = self
       // brithDay.addTarget(self, action: "handleDatePicker:", forControlEvents: UIControlEvents.TouchDown)
        customPicker()
       
        let url = "https://nickgormanacademy.com/soccerSquat/selectUser.php"
        let parame:[String:String] = ["uid": userId]
        
        Alamofire.request(.GET,url, parameters: parame, encoding: .URL).validate()
            
            .responseJSON{(response) in
                //print("love_you1")
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.player_id = (value["uid"] as? String)!
                    self.player_name = (value["uname"] as? String)!
                    self.player_tel = (value["uphone"] as? String)!
                    self.player_gender = (value["usex"] as? String)!
                    self.player_position = (value["uposition"] as? String)!
                    self.player_status = (value["ustatus"] as? String)!
                    self.player_image = (value["uimage"] as? String)!
                    self.player_birthday = (value["ubirthday"] as? String)!
                    
                    var urlString = "https://nickgormanacademy.com/soccerSquat/singup/singupImage/"+self.player_image
                    
                    
                    self.getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
                        self.imageUser.image = image
                        self.imageUser.contentMode = .ScaleAspectFill
                        self.imageUser.layer.borderWidth = 1.0
                        self.imageUser.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
                        self.imageUser.layer.masksToBounds = false
                        self.imageUser.layer.cornerRadius = self.imageUser.frame.size.height/2
                        self.imageUser.clipsToBounds = true
                    }
         
                }
                
                self.name.text = self.player_name
                self.position.text = self.player_position
                self.sex.text = self.player_gender
                self.phone.text = self.player_tel
                self.brithDay.text = self.player_birthday
                self.statusTextView.text = self.player_status
                
                // Do any additional setup after loading the view.
        }
        
      
        // Do any additional setup after loading the view.
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func choosePhoto(sender: AnyObject) {
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
        
        if self.name.text == "" {
            MyAlerts("Please your enter name!")
        }else {
            
            uploadProfile()
            self.performSegueWithIdentifier("unwindToHome", sender: self)
        }
        
        
    }
    
    func uploadProfile() {
        Activity().showLoading()
        var pass_name = self.name.text!
        var pass_phone = self.phone.text!
        var pass_gender = self.sex.text!
        var pass_position = self.position.text!
        var pass_status = self.statusTextView.text
        var pass_birthDay = self.brithDay.text
        
        let url = "https://nickgormanacademy.com/soccerSquat/UpDate_DataUser.php"
        let parame:[String:String] = ["user_id": userId, "name": pass_name , "phone": pass_phone , "position":pass_position , "sex":pass_gender , "status":pass_status, "birthday": pass_birthDay!]
        
        
        
        Alamofire.upload(.POST, url,headers: parame ,multipartFormData: {multipartFormData in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageUser.image!,0.4)! ,name: "file", fileName: "image", mimeType: "singupImage/")
            
            
            for (key, value) in parame {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
            }
            
            } ,  encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { (response) in
                        
                        print("update success")
                         Activity().hideLoading()
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
                
        })

    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageUser.contentMode = .ScaleAspectFill
            imageUser.image = pickedImage
        }else if let pickerImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageUser.contentMode = .ScaleAspectFill
            imageUser.image = pickerImage
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newLength:Int = 0
        if textField == name {
            guard let text = name.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 30
            
        }else if textField == phone {
            guard let text = phone.text else { return true }
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
        
        countLabel.text = String(remainingChars)
        
        
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
        
        if pickerView.tag == 0 {
            return pickOption.count
        }else if pickerView.tag == 1 {
            return PositionOption.count
        }else if pickerView.tag == 3 {
        print("cb")}
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return pickOption[row]
        }else if pickerView.tag == 1 {
            return PositionOption[row]
        }
        else if pickerView.tag == 3 {
            print("pp")}
        
        return ""
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            sex.text = pickOption[row]
        }else if pickerView.tag == 1 {
            print("zzz")
            position.text = PositionOption[row]
        }else if pickerView.tag == 3 {
            print("date///")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.timeStyle = .NoStyle
            
            brithDay.text = dateFormatter.stringFromDate(datePickerView.date)
            self.view.endEditing(true)
        }
    }
    
    
    func donePressed(sender: UIBarButtonItem) {
        
        sex.resignFirstResponder()
        position.resignFirstResponder()
        brithDay.resignFirstResponder()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        print(sender.tag)
        brithDay.text = dateFormatter.stringFromDate(datePickerView.date)
        self.view.endEditing(true)
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        sex.text = "Male"
        position.text = "Forward"
        brithDay.text = ""
        sex.resignFirstResponder()
        position.resignFirstResponder()
        brithDay.resignFirstResponder()
    }
    
    func customPicker() {
        
        self.btn.layer.cornerRadius  = 12
        self.btn.layer.borderWidth = 1.0
        self.btn.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        datePickerView.datePickerMode = UIDatePickerMode.Date
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        let pickerView2 = UIPickerView()
        pickerView2.delegate = self
        
        //datePickerView.delegate = self
        sex.inputView = pickerView
        position.inputView = pickerView2
        brithDay.inputView = datePickerView
        pickerView.tag = 0
        pickerView2.tag = 1
        datePickerView.tag = 3
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackOpaque
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(updateplayerprofile.tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(updateplayerprofile.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        label.text = "Pick type"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        sex.inputAccessoryView = toolBar
        position.inputAccessoryView = toolBar
        brithDay.inputAccessoryView = toolBar
        
        
    }


}
