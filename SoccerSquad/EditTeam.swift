//
//  EditTeam.swift
//  Project2
//
//  Created by toffee on 6/30/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AssetsLibrary

class EditTeam: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var nameTeam: UITextField!
    @IBOutlet weak var imageTeam: UIImageView!
    @IBOutlet weak var detailTeam: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    
    
    var tid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
            print("tid = \(tid)")
        self.doEdit()

    }
    
    func doEdit() {
        let parame4:[String:String] = ["tid": self.tid ]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/team/dataTeam.php"
        
        self.detailTeam.layer.borderWidth = 1.0
        self.detailTeam.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
        btnSave.layer.cornerRadius = 12
        btnSave.layer.borderWidth = 1
        //self.nameTeam.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0).CGColor
        
        Alamofire.request(.GET,urlSring ,parameters: parame4 ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                
                switch response.result {// เช็คว่ามีข้อมูลไหม
                case .Success:
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    
                    for value in JSON {
                        self.nameTeam.text  = (value["tname"] as? String)!
                        self.detailTeam.text  = (value["tdetail"] as? String)!
                        
                        
                        var urlString = "https://nickgormanacademy.com/soccerSquat/image/" + (value["timage"] as? String)!
                        
                        
                        self.getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
                            self.imageTeam.image = image
                            //self.imageUser.contentMode = .ScaleAspectFit
                            self.imageTeam.layer.borderWidth = 1.0
                            self.imageTeam.layer.masksToBounds = false
                            self.imageTeam.layer.cornerRadius = self.imageTeam.frame.size.height/2
                            self.imageTeam.clipsToBounds = true
                        }

                    }
                    
                    self.tableView.reloadData()
                    
                    
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    @IBAction func doPhoto(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        print(myPickerController.accessibilityPath)
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imageTeam.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        // print("nameImage = \()")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    @IBAction func updateTeam(sender: AnyObject) {
        
        
        let url = "https://nickgormanacademy.com/soccerSquat/team/UpdateTeam.php"
        let parame:[String:String] = ["tid": self.tid, "nameTeam": self.nameTeam.text! , "detailTeam": self.detailTeam.text ]
        
        
        
        Alamofire.upload(.POST, url,headers: parame ,multipartFormData: {multipartFormData in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageTeam.image!,0.4)! ,name: "file", fileName: "image", mimeType: "image/")
            
            
            for (key, value) in parame {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
            }
            
            } ,  encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { (response) in
                        
                        print("xx")
                        
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
                
        })
        
        
        var alert = UIAlertView(title: "Success", message: "Edit Success", delegate: self, cancelButtonTitle: "OK")
        alert.show()
        
        
        
    }
    
    

   }
