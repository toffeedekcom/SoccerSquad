//
//  EventPicture.swift
//  Project2
//
//  Created by Jay on 6/28/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit

protocol EventPic {
    func imageData(image: UIImage)
}

class EventPicture: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegate:EventPic?
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var imgTour: UIImageView!
    @IBOutlet weak var changePic: UIButton!
    
    @IBAction func changePicMode(sender: AnyObject) {
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        navigationController?.delegate = self
        
        imgTour.layer.borderWidth = 1.0
        imgTour.layer.masksToBounds = false
        imgTour.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        imgTour.layer.cornerRadius = imgTour.frame.size.height/2
        imgTour.clipsToBounds = true
        
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            print("Internet connection : OK")
        }
        else {
            MyAlerts("Make sure your device is connected to the internet.")
            
        }
        changePic.layer.cornerRadius = 12
        changePic.layer.borderWidth = 1
        changePic.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgTour.contentMode = .ScaleAspectFill
            imgTour.image = pickedImage
        }else if let pickerImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgTour.contentMode = .ScaleAspectFill
            imgTour.image = pickerImage
        }
        
        self.delegate?.imageData(self.imgTour.image!)
        
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
    }
    


    
}
