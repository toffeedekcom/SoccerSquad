//
//  EditFieldProfileView.swift
//  Project2
//
//  Created by Jay on 6/27/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class EditFieldProfileView: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    let urlUpdetaField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/updateField.php"
    var uid = userId
    var fieldID = ""
    var namefield = ""
    var typefield = ""
    var countfield = ""
    var openfield = ""
    var closefield = ""
    var streetfield = ""
    var cityfield = ""
    var country = ""
    var zipfield = ""
    var pricefield = ""
    var telfield = ""
    var imagefield = ""
    var latitude = ""
    var longtitude = ""
    
    var updateLatitude = ""
    var updateLongtitude = ""
    
    
    
    let imagePicker = UIImagePickerController()
    var pickOption = ["Outdoor-turf" , "Indoor-turf", "Outdoor-artificial turf", "Indoor-artificial turf", "Outdoor-concrete", "Indoor-concrete", "etc."]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var streetTexField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var telTextField: UITextField!
    
    @IBOutlet weak var opentimeTextField: UITextField!
    
    @IBOutlet weak var closetimeTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBAction func updateFieldButton(sender: AnyObject) {
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            print("Internet connection : OK")
            CheckUpdateField()
            
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        
    }
    
    
    
    @IBAction func dateTextFieldEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(editFieldController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    @IBAction func dateTextFieldEditing2(sender: UITextField) {
        
        let datePickerView2:UIDatePicker = UIDatePicker()
        
        datePickerView2.datePickerMode = UIDatePickerMode.Time
        
        sender.inputView = datePickerView2
        
        datePickerView2.addTarget(self, action: #selector(editFieldController.datePickerValueChanged2), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if (segue.identifier == "editpictureField") {
            (segue.destinationViewController as! EditFieldPictureProfileView).delegate = self
            
        } else if (segue.identifier == "editlocationField"){
            (segue.destinationViewController as! EditFieldMapProfileView).delegate2 = self
        } else{
            print("unkown segue")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        typeTextField.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackOpaque
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditFieldProfileView.tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(EditFieldProfileView.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
        label.text = "Pick Field type"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        typeTextField.inputAccessoryView = toolBar
        
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
        self.imageView.clipsToBounds = true

        
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            print("Internet connection : OK")
            self.nameTextField.text = self.namefield
            self.typeTextField.text = self.typefield
            self.streetTexField.text = self.streetfield
            self.cityTextField.text = self.cityfield
            self.countryTextField.text = self.country
            self.zipTextField.text = self.zipfield
            self.telTextField.text = self.telfield
            self.priceTextField.text = self.pricefield
            self.opentimeTextField.text = self.openfield
            self.closetimeTextField.text = self.closefield
            self.locationLabel.text = self.latitude+","+self.longtitude
            getImage()
            
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        
        
    }
    
    func getImage() {
        var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.imagefield
        
        if urlImage.isEmpty {
            self.imageView.image = UIImage(named: "team")
        }else {
            
            self.downloadImage(urlImage) { (image) in
                
                if image == nil {
                    self.imageView.image = UIImage(named: "team")
                    
                }else {
                    
                    self.imageView.image = image
                    
                }
            }
            
        }
        
        
        
    }
    
    func CheckUpdateField() {
        
        self.namefield = self.nameTextField.text!
        self.typefield = self.typeTextField.text!
        self.streetfield = streetTexField.text!
        self.cityfield = cityTextField.text!
        self.country = countryTextField.text!
        self.zipfield = zipTextField.text!
        self.telfield = telTextField.text!
        self.pricefield = priceTextField.text!
        self.openfield = opentimeTextField.text!
        self.closefield = closetimeTextField.text!
        self.latitude = updateLatitude
        self.longtitude = updateLongtitude

        let parameter:[String:String] = ["FieldID": fieldID, "name_Field": namefield, "street_Field":streetfield, "city_Field":cityfield, "country_Field":country, "zip_Field":zipfield, "latitude_Field":updateLatitude, "longtitude_Field":updateLongtitude, "tel_Field":telfield, "open_Field":openfield, "close_Field":closefield, "price_Field":pricefield, "type_Field":typefield, "Count_Field":countfield]
        
        if (namefield.isEqual("")){
            
            MyAlerts("Please your put Field name.")
        }
        else{
            
            Alamofire.upload(.POST, urlUpdetaField,headers: parameter ,multipartFormData: {multipartFormData in
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageView.image!,0.4)! ,name: "file", fileName: self.namefield+".JPEG", mimeType: "imageOwner/")
                
                
                for (key, value) in parameter {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                }
                
                } ,  encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { (response) in

                            self.MyAlerts("Update Field Success!")
                            
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                    
            })
        }
        
    }
    
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
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
    
    
    //Function Date Open Fields
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        
        opentimeTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    //Function Date Close Fields
    func datePickerValueChanged2(sender:UIDatePicker) {
        
        let dateFormatter1 = NSDateFormatter()
        
        dateFormatter1.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter1.dateStyle = NSDateFormatterStyle.NoStyle
        
        closetimeTextField.text = dateFormatter1.stringFromDate(sender.date)
        
    }
    
    //download image in database
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) {
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            //print(image)
            completion(image_Field)
        }
    }
    
    
    
}

extension EditFieldProfileView: EditFieldMap {
    func updateLatitudeProfile(latitudeProfile: String) {
        self.updateLatitude = latitudeProfile

    }
    
    func updateLongtitudeProfile(longtitudeProfile: String) {
        self.updateLongtitude = longtitudeProfile
        
    }
}
extension EditFieldProfileView: EditFieldPicture {
    func updatePictureField(dataProfile: UIImage) {
        self.imageView.image = dataProfile
        
    }
}

