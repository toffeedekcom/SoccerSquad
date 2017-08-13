//
//  editFieldController.swift
//  Project2
//
//  Created by CSmacmini on 6/25/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class editFieldController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let urlUpdetaField = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/updateField.php"
    var uid = userId
    var namefield = ""
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
    var statusField = "1"
    
    
    var updateLatitude = ""
    var updateLongtitude = ""
    var limitLength = 0
    
    
    
    //Photo
    let imagePickerController = UIImagePickerController()
    var pickOption = ["Outdoor-turf" , "Indoor-turf", "Outdoor-artificial turf", "Indoor-artificial turf", "Outdoor-concrete", "Indoor-concrete", "etc."]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var streetTexField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var telTextField: UITextField!
    
    @IBOutlet weak var opentimeTextField: UITextField!
    
    @IBOutlet weak var closetimeTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var customButton: UIButton!
    
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
    
    @IBAction func updateFieldButton(sender: AnyObject) {
        
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.CheckUpdateField()
                    self.performSegueWithIdentifier("unwindToFieldDetail", sender: self)
                }else if(net?.isReachableOnWWAN)! {
                    self.CheckUpdateField()
                    self.performSegueWithIdentifier("unwindToFieldDetail", sender: self)
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

        if (segue.identifier == "editlocation") {
            (segue.destinationViewController as! fieldlocation).delegate = self
            
        } else{
            print("unkown segue")
        }

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        streetTexField.delegate = self
        cityTextField.delegate = self
        countryTextField.delegate = self
        zipTextField.delegate = self
        telTextField.delegate = self
        priceTextField.delegate = self
        opentimeTextField.delegate = self
        closetimeTextField.delegate = self
        
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.nameTextField.text = self.namefield
                    self.streetTexField.text = self.streetfield
                    self.cityTextField.text = self.cityfield
                    self.countryTextField.text = self.country
                    self.zipTextField.text = self.zipfield
                    self.telTextField.text = self.telfield
                    self.priceTextField.text = self.pricefield
                    self.opentimeTextField.text = self.openfield
                    self.closetimeTextField.text = self.closefield
                    self.locationLabel.text = self.latitude+","+self.longtitude
                    self.getImage()
                }else if(net?.isReachableOnWWAN)! {
                    self.nameTextField.text = self.namefield
                    self.streetTexField.text = self.streetfield
                    self.cityTextField.text = self.cityfield
                    self.countryTextField.text = self.country
                    self.zipTextField.text = self.zipfield
                    self.telTextField.text = self.telfield
                    self.priceTextField.text = self.pricefield
                    self.opentimeTextField.text = self.openfield
                    self.closetimeTextField.text = self.closefield
                    self.locationLabel.text = self.latitude+","+self.longtitude
                    self.getImage()
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
                    self.imageView.contentMode = .ScaleAspectFill
                    self.imageView.layer.borderWidth = 2.0
                    self.imageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
                    self.imageView.layer.masksToBounds = false
                    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
                    self.imageView.clipsToBounds = true
                    
                }
            }
            
        }
        
        

    }
    
    func CheckUpdateField() {
        Activity().showLoading()
        self.namefield = self.nameTextField.text!
        self.streetfield = self.streetTexField.text!
        self.cityfield = self.cityTextField.text!
        self.country = self.countryTextField.text!
        self.zipfield = self.zipTextField.text!
        self.telfield = self.telTextField.text!
        self.openfield = self.opentimeTextField.text!
        self.closefield = self.closetimeTextField.text!
        self.pricefield = self.priceTextField.text!
        
        let parameter:[String:String] = ["FieldID": global_fieldID, "name_Field": namefield, "street_Field":streetfield, "city_Field":cityfield, "country_Field":country, "zip_Field":zipfield, "latitude_Field":updateLatitude, "longtitude_Field":updateLongtitude, "tel_Field":telfield, "open_Field":openfield, "close_Field":closefield, "price_Field":pricefield, "status_Field": statusField]
        

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

                            Activity().hideLoading()
                            
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                    
            })

        
    }


    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
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
            limitLength = 20
            
        }else if textField == streetTexField {
            guard let text = streetTexField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
        }else if textField == cityTextField {
            guard let text = cityTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
        }else if textField == countryTextField {
            guard let text = countryTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 30
        }else if textField == zipTextField {
            guard let text = zipTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 10
        }else if textField == opentimeTextField {
            guard let text = opentimeTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 15
        }else if textField == closetimeTextField {
            guard let text = closetimeTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 15
        }else if textField == priceTextField {
            guard let text = priceTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 6
        }else if textField == telTextField {
            guard let text = telTextField.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 10
        }
        else {
            print("Other TextField")
        }
        
        
        return newLength <= limitLength
    }


}

extension editFieldController: VCTwoDelegate {
    func updateLatitude(latitude: String) {
        self.updateLatitude = latitude
    }
    
    func updateLongtitude(lontitude: String) {
        self.updateLongtitude = lontitude
    }
}
