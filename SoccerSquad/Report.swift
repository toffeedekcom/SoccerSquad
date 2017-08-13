//
//  Report.swift
//  Project2
//
//  Created by toffee on 7/10/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Report: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var toPicText: UITextField!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var date: UITextField!
    
    
    
    
    
    var toPic = ["User has committed an offense","The application has a problem","User has committed an offense"]
    
     var pickerViewToPic = UIPickerView()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        btnReport.layer.cornerRadius = 12
        pickerViewToPic.delegate = self
        pickerViewToPic.dataSource = self
        toPicText.inputView = pickerViewToPic
        toPicText.addTarget(self, action: "doPicker:", forControlEvents: UIControlEvents.TouchDown)
       
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return toPic.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return toPic[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            toPicText.text = toPic[row]
       
    }
    
    @IBAction func uploadImage(sender: AnyObject) {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        print(myPickerController.accessibilityPath)
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
    }
    
    
    @IBAction func Report(sender: AnyObject) {
        
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Confirm Report", message: "you want to Report ?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            
            if(self.toPicText.text == ""){
                var alert = UIAlertView(title: "Error", message: "Please enter a topic.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            }
            else if(self.detail.text == ""){
                
                var alert = UIAlertView(title: "Error", message: "Please enter a detail.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else if(self.date.text == ""){
                
                var alert = UIAlertView(title: "Error", message: "Please enter a date.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else if(self.image.image == nil){
                
                var alert = UIAlertView(title: "Error", message: "Please enter a image.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }else{
                
                Activity().showLoading()
                
                let parameter:[String:String] = ["uid":userId, "topic": self.toPicText.text!, "detail": self.detail.text, "date": self.date.text!]
                let url = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/insertReport.php"
                
                
                Alamofire.upload(.POST, url,headers: parameter ,multipartFormData: {multipartFormData in
                    multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.image.image!,0.4)! ,name: "file", fileName:"image", mimeType: "imageOwner/")
                    
                    
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
        
        
        
            
            
        
    }
    
    


   
}
