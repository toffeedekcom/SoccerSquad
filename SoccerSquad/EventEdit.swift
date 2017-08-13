//
//  EventEdit.swift
//  Project2
//
//  Created by CSmacmini on 6/24/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class EventEdit: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var ImageTournament: UIImageView!
    @IBOutlet weak var ImageVenue: UIImageView!
    
    @IBOutlet weak var NameVenue: UILabel!
    @IBOutlet weak var NameTournament: UITextField!
    @IBOutlet weak var DetailTournament: UITextView!
    @IBOutlet weak var StartTournament: UITextField!
    @IBOutlet weak var StopTournament: UITextField!
    @IBOutlet weak var CountTeam: UITextField!
    @IBOutlet weak var customButton: UIButton!
    
    var url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/SelectedEvent.php"
    var urlUpdate = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectTournament.php"
    var uid = userId
    var userid = ""
    var fid = ""
    var tourid = ""
    var tourname = ""
    var tourdetail = ""
    var tourcount = ""
    var tourstart = ""
    var tourstop = ""
    var tourimage = ""
    
    var VenueID = ""
    var VenueNAME = ""
    var VenueIMG = ""
    var pass_ImageVenue:UIImage?
    
    let imagePickerController = UIImagePickerController()
    
    var limitLength = 0
    let limitLengthtextView = 250
    
    @IBAction func Choosephoto(sender: AnyObject) {
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
        
        let allowedChars = 250
        
        let charsInTextView = -DetailTournament.text.characters.count
        
        let remainingChars = allowedChars + charsInTextView
        
        //Update Tournament in App
        if ImageTournament.image == nil {
            MyAlerts("Please your choose photo!")
        }else if ImageVenue.image == nil {
            MyAlerts("Please your select place!")
        }else if NameTournament.text == "" {
            MyAlerts("Please your enter title!")
        }else if DetailTournament.text == "" {
            MyAlerts("Please your enter detail!")
        }else if StartTournament.text == "" {
            MyAlerts("Please your enter start tournament!")
        }else if StopTournament.text == "" {
            MyAlerts("Please your enter stop tournament!")
        }else if CountTeam.text == "" {
            MyAlerts("Please yout enter count team!")
        }else {
            //Check connected network
            let net = NetworkReachabilityManager()
            net?.startListening()
            
            net?.listener = {status in
                
                if  net?.isReachable ?? false {
                    
                    if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                        self.updateTournament()
                        self.performSegueWithIdentifier("unwindToTournamentDetail", sender: self)
                    }else if(net?.isReachableOnWWAN)! {
                        self.updateTournament()
                        self.performSegueWithIdentifier("unwindToTournamentDetail", sender: self)
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
    
    @IBAction func dateTapped(sender: UITextField) {
        
        var datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        StartTournament.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        StartTournament.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func dateTapped2(sender: UITextField) {
        
        var datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        StopTournament.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker2:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    func handleDatePicker2(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        StopTournament.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func unwindToEditTournament(segue:UIStoryboardSegue) {
        print("back Edit tournament")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "tournamentVenue" {
            (segue.destinationViewController as! EventVenue).delegate = self
        } else {
            print("Unkown Segue")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Image View
        customImage()
        imagePickerController.delegate = self
        navigationController?.delegate = self
        NameTournament.delegate = self
        CountTeam.delegate = self
        StartTournament.delegate = self
        StopTournament.delegate = self
        DetailTournament.delegate = self
        
        //Check connected network
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            
            if  net?.isReachable ?? false {
                
                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    self.selectTournament()
                    self.NameVenue.text = self.VenueNAME
                    self.ImageVenue.image = self.pass_ImageVenue
                }else if(net?.isReachableOnWWAN)! {
                    self.selectTournament()
                    self.NameVenue.text = self.VenueNAME
                    self.ImageVenue.image = self.pass_ImageVenue
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
    
    func customImage() {
        
        self.ImageTournament.contentMode = .ScaleAspectFill
        self.ImageTournament.layer.borderWidth = 1.0
        self.ImageTournament.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
        self.ImageTournament.layer.masksToBounds = false
        self.ImageTournament.layer.cornerRadius = self.ImageTournament.frame.size.height/2
        self.ImageTournament.clipsToBounds = true

        ImageVenue.contentMode = .ScaleAspectFill
        ImageVenue.layer.borderWidth = 1.0
        ImageVenue.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor;
        ImageVenue.layer.masksToBounds = false
        ImageVenue.layer.cornerRadius = ImageVenue.frame.size.height/2
        ImageVenue.clipsToBounds = true
        
        customButton.layer.cornerRadius = 12
        customButton.layer.borderWidth = 1
        customButton.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor


    }
    
    func selectTournament() {
        
        var parameter:[String:String] = ["uid": uid, "segmemt":"1"]
        
        Activity().showLoading()
        Alamofire.request(.GET,url ,parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                if response.result.value == nil {
                    print("Not found data")
                }
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.tourid = (value["tourid"] as? String)!
                    self.tourname = (value["tourname"] as? String)!
                    self.tourdetail = (value["tourdetail"] as? String)!
                    self.tourstart = (value["tour_date"] as? String)!
                    self.tourstop = (value["tour_todate"] as? String)!
                    self.tourimage = (value["tourimage"] as? String)!
                    self.tourcount = (value["tour_count"] as? String)!
                    self.userid = (value["uid"] as? String)!
                    self.fid = (value["fid"] as? String)!
                    
                }
                
                self.NameTournament.text = self.tourname
                self.DetailTournament.text = self.tourdetail
                self.StartTournament.text = self.tourstart
                self.StopTournament.text = self.tourstop
                self.CountTeam.text = self.tourcount
                
                var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.tourimage
                
                if urlImage.isEmpty {
                    self.ImageTournament.image = UIImage(named: "picture")
                }else {
                    
                    self.downloadImage(urlImage) { (image) in
                        
                        if image == nil {
                            self.ImageTournament.image = UIImage(named: "picture")
                            
                        }else {
                            self.ImageTournament.image = image
                            Activity().hideLoading()
                        }
                    }
                    
                }

        }
     
    }
    
    func updateTournament() {
        Activity().showLoading()
        tourname = self.NameTournament.text!
        tourdetail = self.DetailTournament.text
        tourstart = self.StartTournament.text!
        tourstop = self.StopTournament.text!
        tourcount = self.CountTeam.text!
        
        let parameter:[String:String] = ["tourID": tourid, "tourName": tourname, "tourDetail":tourdetail, "tourStart":tourstart, "tourStop":tourstop, "tourCount":tourcount,"fid":self.VenueID]
        
            Alamofire.upload(.POST, urlUpdate,headers: parameter ,multipartFormData: {multipartFormData in
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.ImageTournament.image!,0.4)! ,name: "file", fileName: self.tourname+".JPEG", mimeType: "FieldManager/")
                
                
                for (key, value) in parameter {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                }
                
                } ,  encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { (response) in
                            
                            Activity().hideLoading()
                            print("Update Success")
                            
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
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageTournament.contentMode = .ScaleAspectFill
            ImageTournament.image = pickedImage
        }else if let pickerImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            ImageTournament.contentMode = .ScaleAspectFill
            ImageTournament.image = pickerImage
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newLength:Int = 0
        if textField == NameTournament {
            guard let text = NameTournament.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 24
            
        }else if textField == CountTeam {
            guard let text = CountTeam.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 2
            
        }else if textField == StartTournament {
            guard let text = StartTournament.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
            
        }else if textField == StopTournament {
            guard let text = StopTournament.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
            
        }else {
            print("Other TextField")
        }
        
        return newLength <= limitLength
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (DetailTournament.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars <= 250;
        
        
        
    }
    
    func checkRemainingChars() {
        
        let allowedChars = 250
        
        let charsInTextView = -DetailTournament.text.characters.count
        
        let remainingChars = allowedChars + charsInTextView
        
//        charsLabel.text = String(remainingChars)
        
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        checkRemainingChars()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }

}

extension EventEdit: VenueDelegate {
    func VenueID(fieldid: String) {
        self.VenueID = fieldid
        print(self.VenueID)
    }
    func VenueName(name: String) {
        self.VenueNAME = name
        self.NameVenue.text = self.VenueNAME
    }
    func VenueImage(image: String) {
        self.VenueIMG = image
        

        let urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + self.VenueIMG
        
        downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
            
            self.ImageVenue.image = image
            
        }
    }
}
