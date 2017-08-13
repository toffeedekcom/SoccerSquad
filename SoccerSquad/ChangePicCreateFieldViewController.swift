//
//  ChangePicCreateFieldViewController.swift
//  Soccer Squad
//
//  Created by CSmacmini on 6/1/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit

//pass data with image
var imageData:UIImage?

class ChangePicCreateFieldViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //
    @IBOutlet weak var ImageView: UIImageView!
    //
    @IBOutlet weak var ChangePicButton: UIButton!
    
    //Photo
    let imagePicker = UIImagePickerController()

    
    @IBAction func ChangePhotoButton(sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addImage(sender: AnyObject) {
        
        print("Pass data")
        imageData = ImageView.image
        
    }
    
    
    
    
    
    //Function Photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageView.contentMode = .ScaleAspectFill
            ImageView.image = pickedImage
        }else if let pickerImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            ImageView.contentMode = .ScaleAspectFill
            ImageView.image = pickerImage
        }
        
        imageData = self.ImageView.image
//        print(imageData.fieldImage)
        
//        globalImage = ImageView.image
//        print("Image : \(globalImage)")
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //Photo
        imagePicker.delegate = self
        navigationController?.delegate = self
        
        ImageView.layer.borderWidth = 1.0
        ImageView.layer.masksToBounds = false
        ImageView.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        ImageView.layer.cornerRadius = ImageView.frame.size.height/2
        ImageView.clipsToBounds = true
    
        
        //Check connected network
        if Reachabillity.isConnectedToNetwork() == true {
            
            print("Internet connection : OK")
        }
        else {
            
            print("Internet connection FAILED")
            
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            
            alert.show()
            
        }

        
        //
        ChangePicButton.backgroundColor = UIColor.clearColor()
        ChangePicButton.layer.cornerRadius = 12
        ChangePicButton.layer.borderWidth = 1
        ChangePicButton.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor

        imageData = self.ImageView.image
        
    }
    

}
