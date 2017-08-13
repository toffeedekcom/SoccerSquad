//
//  ImageProfileViewController.swift
//  Project2
//
//  Created by toffee on 6/12/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit





class ImageProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
var imgData2: UIImage?
    
    var mode = ""
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func save(sender: AnyObject) {
        
        imgData2 = imageView.image
        
        performSegueWithIdentifier("backImage", sender: self)
        
    }
    let imagePickerController = UIImagePickerController()
    
    
    @IBAction func imageButton(sender: AnyObject) {
        
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImage: UIImage?
        
        
        if let Original = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            selectedImage = Original
            
        } else if let edited = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            selectedImage = edited
        }
        
        if let selectedImages = selectedImage {
            imageView.image = selectedImages
            imgData2 = imageView.image
        }
        
        
      
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.darkGrayColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
        
        imgData2 = imageView.image
        
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "backImage") {
            let navController = segue.destinationViewController as! UINavigationController
            let DestViewController = navController.topViewController as! RegisterTableViewController
            DestViewController.mode = self.mode
            DestViewController.imgData = imgData2
        }
    }

    

}
