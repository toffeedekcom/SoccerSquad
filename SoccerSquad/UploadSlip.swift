//
//  UploadSlip.swift
//  Project2
//
//  Created by toffee on 7/4/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import AssetsLibrary
import Alamofire

class UploadSlip: UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageSlip: UIImageView!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var pay: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnSlip: UIButton!
    
    var bookId = ""
    var checkNilImage = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnUpload.layer.cornerRadius = 12
        self.btnSlip.layer.cornerRadius = 12
        self.doUploadSlip()

    }
    
    func doUploadSlip(){
        
        
        let urlStatusBook = "https://nickgormanacademy.com/soccerSquat/booking/StatusBook.php"
        var parame:[String:String] = ["bookId": self.bookId]
        Alamofire.request(.GET,urlStatusBook,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                       
                        self.total.text = (value["bprice"] as? String)!
                        self.pay.text = (value["bpledge"] as? String)!
                        
                        self.balance.text =  String(Int(self.total.text!)! - Int(self.pay.text!)!)
                        
                    }
                    self.tableView.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }
        
        
    }
    
    
    
    @IBAction func UploadImage(sender: AnyObject) {
        
        self.checkNilImage = "yes"
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        print(myPickerController.accessibilityPath)
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageSlip.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        // print("nameImage = \()")
        self.dismissViewControllerAnimated(true, completion: nil)
       
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comfirmPledge(sender: AnyObject) {
        
        
        if (self.checkNilImage == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter a Proto ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            print("null")
        }
        else{
            
            
            let urlUploadSlip = "https://nickgormanacademy.com/soccerSquat/booking/imageslip/UpLoadSlip1.php"
            var parame:[String:String] = ["bookId": self.bookId, "price":self.total.text!,"balance":self.balance.text!]
            
            Alamofire.upload(.POST, urlUploadSlip,headers: parame ,multipartFormData: {multipartFormData in
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.imageSlip.image!,0.4)! ,name: "file", fileName: "image", mimeType: "imageslip/")
                
                
                for (key, value) in parame {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                }
                
                } ,  encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { (response) in
                          
                            
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                    
            })
            
            
            var alert = UIAlertView(title: "Seccess", message: "Upload Seccess. ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
                      print("Nonull")
        
        }
    }

   
}
