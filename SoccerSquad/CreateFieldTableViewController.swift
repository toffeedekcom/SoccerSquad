//
//  CreateFieldTableViewController.swift
//  Soccer Squad
//
//  Created by Jay on 5/31/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit
import Alamofire

//Variable url Selected List fields data
let urlSelectField = ""

class CreateFieldTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    //
    @IBOutlet weak var FieldNameTextField: UITextField!
    
    //
    @IBOutlet weak var StreetTextField: UITextField!
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var CountryTextField: UITextField!
    @IBOutlet weak var ZipTextField: UITextField!
    
    //
    @IBOutlet weak var TelTextField: UITextField!
    
    //
    @IBOutlet weak var OpenTimeTextField: UITextField!
    @IBOutlet weak var CloseTimeTextField: UITextField!
    
    //
    @IBOutlet weak var PriceTextField: UITextField!
    
    //
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func ChangePhoto(sender: AnyObject) {
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

    
    @IBOutlet weak var locationLabel: UILabel!
    

    //
    @IBAction func addFiedItem(sender: AnyObject) {
        
        if self.FieldNameTextField.text == "" {
            MyAlerts("Please your enter name field!")
        }else if self.StreetTextField.text == ""{
            MyAlerts("Please your enter street field!")
        }else if self.CityTextField.text == "" {
            MyAlerts("Please your enter city field!")
        }else if self.CountryTextField.text == "" {
            MyAlerts("Please your enter country field!")
        }else if self.ZipTextField.text == "" {
            MyAlerts("Please your enter zip field!")
        }else if self.TelTextField.text == "" {
            MyAlerts("Please your enter tel field!")
        }else if self.OpenTimeTextField.text == "" {
            MyAlerts("Please your enter opentime field!")
        }else if self.CloseTimeTextField.text == "" {
            MyAlerts("Please your enter closetime field!")
        }else if self.PriceTextField.text == "" {
            MyAlerts("Please your enter price field!")
        }else if self.imageView.image == "" {
            MyAlerts("Please your choose photo field!")
        }else {
            
            //Check connected network
            let net = NetworkReachabilityManager()
            net?.startListening()
            
            net?.listener = {status in
                
                if  net?.isReachable ?? false {
                    
                    if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                        self.CheckCreateField()
                        self.performSegueWithIdentifier("unwindToField", sender: self)
                    }else if(net?.isReachableOnWWAN)! {
                        self.CheckCreateField()
                        self.performSegueWithIdentifier("unwindToField", sender: self)
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
    
    //Picture
    let imagePickerController = UIImagePickerController()
    var limitLength = 0
    
    
    var pickOption = [["00:00" , "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"], ["AM", "PM"]]
    
    var pickOption2 = [["00:00" , "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"], ["AM", "PM"]]
    
    var OwnerID = String()
    var FieldImage = UIImage()
    var FieldName = String()
    var FieldStreet = String()
    var FieldCity = String()
    var FieldCountry = String()
    var FieldZip = String()
    var FieldLatitude = String()
    var FieldLongtitude = String()
    var FieldTel = String()
    var FieldOpen = String()
    var FieldClose = String()
    var FieldPrice = String()
    var FieldType = String()
    
    var status = "ON"
    var updateLatitude = ""
    var updateLongtitude = ""
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
    
    //Function Checking Email
    func isValidEmail(testStr:String) -> Bool {
        print("Validcate email: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        
        return result
        
    }

    
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "ChooseImageField" {
            (segue.destinationViewController as! MapViewController).delegate = self
        }else {
            print("Unknow segue")
        }
        
    }

    func CheckCreateField() {
        Activity().showLoading()
        
        FieldName = self.FieldNameTextField.text!
        FieldImage = self.imageView.image!
        FieldStreet = self.StreetTextField.text!
        FieldCity = self.CityTextField.text!
        FieldCountry = self.CountryTextField.text!
        FieldZip = self.ZipTextField.text!
        FieldLatitude = updateLatitude
        FieldLongtitude = updateLongtitude
        FieldTel = self.TelTextField.text!
        FieldPrice = self.PriceTextField.text!
        OwnerID = userId
        
        let urlSring = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/CreateField.php"
        let parameter:[String:String] = ["id_Owner": OwnerID, "name_Field": FieldName, "street_Field":FieldStreet, "city_Field":FieldCity, "country_Field":FieldCountry, "zip_Field":FieldZip, "latitude_Field":FieldLatitude, "longtitude_Field":FieldLongtitude, "tel_Field":FieldTel, "open_Field":self.OpenTimeTextField.text!, "close_Field":self.CloseTimeTextField.text!, "price_Field":FieldPrice, "status_Field": status]
        
            
            Alamofire.upload(.POST, urlSring,headers: parameter ,multipartFormData: {multipartFormData in
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageView.image!,0.4)! ,name: "file", fileName: self.FieldName+".JPEG", mimeType: "imageOwner/")
                
                
                for (key, value) in parameter {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                }
                
                } ,  encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { (response) in
                            
                            print(parameter)
                            print("Success")
                            Activity().hideLoading()
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                    
            })
        
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newLength:Int = 0
        if textField == FieldNameTextField {
            guard let text = FieldNameTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
            
        }else if textField == StreetTextField {
            guard let text = StreetTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
        }else if textField == CityTextField {
            guard let text = CityTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
        }else if textField == CountryTextField {
            guard let text = CountryTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 30
        }else if textField == ZipTextField {
            guard let text = ZipTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 10
        }else if textField == OpenTimeTextField {
            guard let text = OpenTimeTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 15
        }else if textField == CloseTimeTextField {
            guard let text = CloseTimeTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 15
        }else if textField == PriceTextField {
            guard let text = PriceTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 6
        }else if textField == TelTextField {
            guard let text = TelTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 10
        }
        else {
            print("Other TextField")
        }
        
        
        return newLength <= limitLength
    }

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            return pickOption[component].count
        }else if pickerView.tag == 1 {
            return pickOption2[component].count
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return pickOption[component][row]
        }else if pickerView.tag == 1 {
            return pickOption2[component][row]
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            OpenTimeTextField.text = pickOption[0][pickerView.selectedRowInComponent(0)]
        }else if pickerView.tag == 1 {
            CloseTimeTextField.text = pickOption2[0][pickerView.selectedRowInComponent(0)]
        }
        
        
        
    }
    
    
    func donePressed(sender: UIBarButtonItem) {
        
        OpenTimeTextField.resignFirstResponder()
        CloseTimeTextField.resignFirstResponder()
        
    }

    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        OpenTimeTextField.text = "00:00"
        CloseTimeTextField.text = "00:00"
        
        OpenTimeTextField.resignFirstResponder()
        CloseTimeTextField.resignFirstResponder()
    }


    func customIU() {
        
        //Custom type UI Picker
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        let pickerView2 = UIPickerView()
        pickerView2.delegate = self
        OpenTimeTextField.inputView = pickerView
        CloseTimeTextField.inputView = pickerView2
        
        pickerView.tag = 0
        pickerView2.tag = 1
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackOpaque
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateFieldTableViewController.tappedToolBarBtn))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(CreateFieldTableViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        label.text = "Time"
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        OpenTimeTextField.inputAccessoryView = toolBar
        CloseTimeTextField.inputAccessoryView = toolBar
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customIU()
        navigationController?.delegate = self
        FieldNameTextField.delegate = self
        StreetTextField.delegate = self
        CityTextField.delegate = self
        CountryTextField.delegate = self
        ZipTextField.delegate = self
        TelTextField.delegate = self
        OpenTimeTextField.delegate = self
        CloseTimeTextField.delegate = self
        PriceTextField.delegate = self
        
        self.OpenTimeTextField.tag = 0
        self.CloseTimeTextField.tag = 1

        //
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true

        
        if self.updateLatitude.isEmpty || self.updateLongtitude.isEmpty {
            locationLabel.text = "Location"
        }else {
            locationLabel.text = self.updateLatitude+" "+self.updateLongtitude
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
    }
    
}

extension CreateFieldTableViewController: mapDelegate {
    func latitudeData(latitude: String) {
        self.updateLatitude = latitude
        print(self.updateLatitude)
        
    }
    func longtitudeData(longtitude: String) {
        self.updateLongtitude = longtitude
        print(updateLongtitude)
    }
}


