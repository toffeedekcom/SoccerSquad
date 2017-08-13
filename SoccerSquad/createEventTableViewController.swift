//
//  createEventTableViewController.swift
//  Soccer Squad
//
//  Created by Jay on 6/6/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class createEventTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var uid = userId
    var url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/CreateEventOwner.php"
    
    var fid = ""
    var nameOwner = ""
    var nameEvent = ""
    var detailEvent = ""
    var startDate = ""
    var stopDate = ""
    var placeEvent = ""
    var placeImage = ""
    var countEvent = ""
    
    
    
    var limitLength = 0
    let limitLengthtextView = 250
    let imagePickerController = UIImagePickerController()

    
    @IBOutlet weak var imagefield: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventname: UITextField!
    @IBOutlet weak var eventdetailTextView: UITextView!
    @IBOutlet weak var eventStart: UITextField!
    @IBOutlet weak var eventStop: UITextField!
    
    @IBOutlet weak var charsLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var countOfTeam: UITextField!
    
    @IBOutlet weak var customBtn: UIButton!
    @IBAction func ChoosePhoto(sender: AnyObject) {
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
        
        let charsInTextView = -eventdetailTextView.text.characters.count
        
        let remainingChars = allowedChars + charsInTextView
        
        if imagefield.image == nil {
            MyAlerts("Please your choose photo!")
        }else if imageView.image == nil {
            MyAlerts("Please your select place!")
        }else if eventname.text == "" {
            MyAlerts("Please your enter title!")
        }else if eventdetailTextView.text == "" {
            MyAlerts("Please your enter detail!")
        }else if countOfTeam.text == "" {
            MyAlerts("Please your enter count team!")
        }else if eventStart.text == "" {
            MyAlerts("Please your enter start tournament!")
        }else if eventStop.text == "" {
            MyAlerts("Please your enter stop tournament!")
        }else {
        
        CheckCreateEvent()
        self.performSegueWithIdentifier("unwindToTournament", sender: self)
            
        }
    }
    //
    @IBAction func dateTextFieldEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(createEventTableViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    @IBAction func unwindToCreateTournament(segue:UIStoryboardSegue) {
        print("back Create tournament")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed

        if (segue.identifier == "chooseplace") {
            (segue.destinationViewController as! SearchPlace).delegate = self
            
        }else{
            print("unkown segue")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        CustomUI()
        
        eventname.delegate = self
        countOfTeam.delegate = self
        eventdetailTextView.delegate = self
        eventStart.delegate = self
        eventStop.delegate = self
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            print("Internet connection : OK")
        }
        else {
            
            print("Internet connection FAILED")
            
            MyAlerts("กรุณาเชื่อมต่ออินเตอร์เน็ต")
            
        }
        
    }
    
    func CustomUI() {
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
        
        imagefield.layer.borderWidth = 1.0
        imagefield.layer.masksToBounds = false
        imagefield.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        imagefield.layer.cornerRadius = imagefield.frame.size.height/2
        imagefield.clipsToBounds = true
        
        customBtn.layer.cornerRadius = 10
        customBtn.layer.borderWidth = 1.0
        customBtn.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
    }
    

    
    //
    @IBAction func dateTextFieldEditing2(sender: UITextField) {
        
        let datePickerView2:UIDatePicker = UIDatePicker()
        
        datePickerView2.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView2
        
        datePickerView2.addTarget(self, action: #selector(createEventTableViewController.datePickerValueChanged2), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    //Function Date start Fields
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()

        
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        eventStart.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    //Function Date stop Fields
    func datePickerValueChanged2(sender:UIDatePicker) {
        
        let dateFormatter1 = NSDateFormatter()

        
        dateFormatter1.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        eventStop.text = dateFormatter1.stringFromDate(sender.date)
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        var newLength:Int = 0
        if textField == eventname {
            guard let text = eventname.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 24
            
        }else if textField == countOfTeam {
            guard let text = countOfTeam.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 2
            
        }else if textField == eventStart {
            guard let text = eventStart.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
            
        }else if textField == eventStop {
            guard let text = eventStop.text else { return true }
            newLength = text.characters.count + string.characters.count - range.length
            limitLength = 20
            
        }else {
            print("Other TextField")
        }
        
        return newLength <= limitLength
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (eventdetailTextView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars <= 250;
        
        
        
    }
    
    func checkRemainingChars() {
        
        let allowedChars = 250
        
        let charsInTextView = -eventdetailTextView.text.characters.count
        
        let remainingChars = allowedChars + charsInTextView
        
        charsLabel.text = String(remainingChars)
        
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        checkRemainingChars()
    }
    
    
    
    //Alert Message Login Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"แจ้งเตือน", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func CheckCreateEvent() {
        Activity().showLoading()
        nameEvent = self.eventname.text!
        detailEvent = self.eventdetailTextView.text
        startDate = self.eventStart.text!
        stopDate = self.eventStop.text!
        countEvent = self.countOfTeam.text!
        
        let parameter:[String:String] = ["uid": uid, "nameEvent": nameEvent, "detailEvent":detailEvent, "startDate":startDate, "stopDate":stopDate, "count_Event": countEvent,"fid":fid]
        
        print(parameter)
        
            Alamofire.upload(.POST, url,headers: parameter ,multipartFormData: {multipartFormData in
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageView.image!,0.4)! ,name: "file", fileName: self.nameEvent+".JPEG", mimeType: "FieldManager/")
                
                
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
    
    func downloadImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image_Field = response.result.value else { return }
            completion(image_Field)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    
}

extension createEventTableViewController: PlaceDelegate {
    func placeData(name: String){
        self.placeLabel.text = name
        
    }
    
    func placeImage(id: String) {
        self.placeImage = id
        
        let urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + placeImage

            downloadImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                
                self.imagefield.image = image
            
        }

        
    }
    
    func placeID(fieldid: String) {
        self.fid = fieldid
        
        print(self.fid)
    }
}


