//
//  CreateTeam.swift
//  ParseDemo
//
//  Created by toffee on 11/3/2559 BE.
//  Copyright © 2559 abearablecode. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AssetsLibrary




class CreateTeam: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var image_team: UIImageView!
    
    @IBOutlet weak var name_team: UITextField!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var discriptionn: UITextView!
   
    @IBOutlet weak var tableview: UITableView!
   
    @IBOutlet weak var searchBar: UISearchBar!
    
   // static let data1 = CreateTeam()
    var filteredAppleProducts = [String]()
    var resultSearchController = UISearchController()
    var data1 = [String]()
    var member = [String]()
    var nn = ""
    var id = ""
    var getname = "" //ดึงข้อมูลจากtableview มาใช้
    var getid = ""
    var filteredData: [String]!
   
     var searchController: UISearchController!

    
    var nameteam = ""
    var numberteam = ""
     var team_id = ""
    var nameTeam = ""
    
    var urlString = "https://nickgormanacademy.com/soccerSquat/image/fff.png"
    var urlRequateImage = "https://nickgormanacademy.com/soccerSquat/image"
    var beginImage: CIImage!
    var id_user = ""
    var dd = HomeViewController()
    
    
    let url_select_dataTeam = "https://nickgormanacademy.com/soccerSquat/select_data_team.php"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        filteredData = data1
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        
        
        
            getNetworkImage(urlString) { (image) in //เรียก เมอธอทดึงรูป
            self.image_team.image = image
        }
       //print("user>\(self.data)")
        
    }
    
    
    
    var uid = ""
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showItemSegue") {
            
            
            let DestViewController = segue.destinationViewController as! DataTeam
            //let DestViewController = navController.topViewController as! DataTeam
            DestViewController.name = name_team.text!
            DestViewController.id_team = self.team_id
            DestViewController.uid = self.uid
            DestViewController.detailTeam = self.discriptionn.text
            
            print("tid = \(self.team_id)")
            print("uid = \(self.uid)")
           
        }
        
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CheckCreateTeam() {
        
        let urlSring = "https://nickgormanacademy.com/soccerSquat/CreateTeam.php"
        nameteam = self.name_team.text!
        var discriptionn = self.discriptionn.text
        nameTeam = self.name_team.text!
        let parame:[String:String] = ["id_user": userId, "name": nameTeam, "discriptionn":discriptionn]
        var checkDupicate = ""
        if (nameteam.isEqual("")){ //เช็คว่ามีการตั้งชื่อทีมไหม
            var alert = UIAlertView(title: "alert", message: "Please enter a team name. ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else{
            
            
            
            Alamofire.upload(.POST, urlSring,headers: parame ,multipartFormData: {multipartFormData in
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.image_team.image!,0.4)! ,name: "file", fileName: self.nameteam+".JPEG", mimeType: "image/")
                for (key, value) in parame {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
                }
                } ,  encodingCompletion: {
                    encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { (response) in
                            var JSON = [AnyObject]()
                            JSON = response.result.value as! [AnyObject]!
                            for value in JSON {
                                checkDupicate = (value["crecklogin"] as? String)!
                                if(checkDupicate == "1"){
                                    var alert = UIAlertView(title: "Invalid", message: "unseccess ", delegate: self, cancelButtonTitle: "OK")
                                    alert.show()
                                }
                                else{
                                    
                                    let parame1:[String:String] = ["name": self.nameTeam ]
                                    Alamofire.request(.GET, self.url_select_dataTeam, parameters: parame1, encoding: .URL).validate()
                                        .responseJSON{(response) in
                                            
                                            print("xxxx = \(response)")
                                            var JSON = [AnyObject]()
                                            JSON = response.result.value as! [AnyObject]!
                                            for value in JSON {
                                                self.team_id  = (value["tid"] as? String)!
                                                self.uid  = (value["uid"] as? String)!
                                            }
                                            self.performSegueWithIdentifier("showItemSegue", sender: self)
                                    }
                                }
                                
                            }
                            print(checkDupicate)
                            
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                    
            })
        }
        
        //self.uploadWithAlamofire()
        
        //        getNetworkImage(urlRequateImage) { (image) in
        //            print(image)
        //            self.image_team.image = image
        //        }

        
    }
    
    
    @IBAction func Create_team(sender: AnyObject) {
        
        if (name_team.text == "") {
            var alert = UIAlertView(title: "Error", message: "Please enter a team name.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else{
             CheckCreateTeam()
        }

       
    }
   
   
    
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
  /////////ดึงรูปจากโทรศัพท์
    @IBAction func loadproto(sender: AnyObject) { //เปิดรูปใน  library
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
           print(myPickerController.accessibilityPath)
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image_team.image = info[UIImagePickerControllerOriginalImage] as? UIImage
       // print("nameImage = \()")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let sqlString = "https://nickgormanacademy.com/soccerSquat/image/image.php"
        let imageData = UIImagePNGRepresentation(image_team.image!)
     
        
  
    }
    
    
    



}

    
    

