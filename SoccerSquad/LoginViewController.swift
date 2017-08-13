//
//  LoginViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/28/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit


//var creck_logi = "" //ตัวแปรโกลบอล จะเก็บข้อมู name ที่ดึงจาก databaes เมื่อlogin

class LoginViewController: UIViewController,UIActionSheetDelegate  {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var loginFB: UIButton!
    
    @IBOutlet weak var customimage: UIImageView!
    
    var username = ""
    var password = ""
    
    var mode = ""
    var numBlock = ""
    var dateBlock = ""
    
    static var test = LoginViewController()
    
    //Variable Facebook
    var fb_id = ""
    var fb_name = ""
    var fb_email = ""
    var fb_picture = ""
    var fb_gender = ""
    var fb_status = ""
    var fb_block = ""
    
    var get_uid = ""
    var get_detail = ""
    var get_email = ""
    var get_email_fb = ""
    
    var decodedimage:UIImage?
    let userNameKeyConstant = "login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customUI()
        
    }
    
    func customUI() {
        
        let bottomLine8 = CALayer()
        bottomLine8.frame = CGRectMake(0.0, usernameField.frame.height - 1, usernameField.frame.width, 1.0)
        usernameField.borderStyle = UITextBorderStyle.None
        usernameField.layer.addSublayer(bottomLine8)
        
        
        let bottomLine0 = CALayer()
        bottomLine0.frame = CGRectMake(0.0, passwordField.frame.height - 1, passwordField.frame.width, 1.0)
        passwordField.borderStyle = UITextBorderStyle.None
        passwordField.layer.addSublayer(bottomLine0)
        
        usernameField.layer.cornerRadius = 17
        passwordField.layer.cornerRadius = 17
        login.layer.cornerRadius = 17
        loginFB.layer.cornerRadius = 17
        
        //        customimage.layer.cornerRadius = customimage.frame.height/2
        //
        //        customimage.layer.borderWidth = 1.0
        //        customimage.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {}
    
    @IBAction func loginAction(sender: AnyObject) {
        
        if self.usernameField.text == "" {
            MyAlerts("Please your enter email address!")
        }else if self.passwordField.text == "" {
            MyAlerts("Please your enter password!")
        }else if isValidEmail(usernameField.text!) == false {
            MyAlerts("Please enter a email address valid!!")
        }else {
                       let net = NetworkReachabilityManager()
            net?.startListening()
            
            net?.listener = {status in
                
                if  net?.isReachable ?? false {
                    
                    if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                        //do some stuff
                        self.checkLogin()
                    }else if(net?.isReachableOnWWAN)! {
                        //do some stuff
                        self.checkLogin()
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
    
    
    @IBAction func loginFacebookAction(sender: AnyObject) {
        
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = {status in
            if  net?.isReachable ?? false {

                if ((net?.isReachableOnEthernetOrWiFi) != nil) {
                    //do some stuff
                    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                    fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
                        if (error == nil){
                            let fbloginresult : FBSDKLoginManagerLoginResult = result
                            
                            if result.isCancelled {
                                return
                            }
                            
                            if(fbloginresult.grantedPermissions.contains("email"))
                            {
                                self.getFBUserData()
                            }
                        }
                    }
                }else if(net?.isReachableOnWWAN)! {
                    //do some stuff
                    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                    fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
                        if (error == nil){
                            let fbloginresult : FBSDKLoginManagerLoginResult = result
                            
                            if result.isCancelled {
                                return
                            }
                            
                            if(fbloginresult.grantedPermissions.contains("email"))
                            {
                                self.getFBUserData()
                            }
                        }
                    }
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
    
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: "Takes the appearance of the bottom bar if specified; otherwise, same as UIActionSheetStyleDefault.", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Owner", style: .Default) { action in
            // ...
            self.mode = "owner"
            self.performSegueWithIdentifier("signUp", sender: self)
            print("OK")
            
        }
        alertController.addAction(OKAction)
        
        let destroyAction = UIAlertAction(title: "Player", style: .Default) { action in
            self.mode = "user"
            self.performSegueWithIdentifier("signUp", sender: self)
            print("Destroy")
            
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true) {
        }
        
    }
    
    
    @IBAction func forgorPassword(sender: AnyObject) {
        performSegueWithIdentifier("resetpassword", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "signUp") {
            let navController = segue.destinationViewController as! UINavigationController
            let DestViewController = navController.topViewController as! RegisterTableViewController
            DestViewController.mode = self.mode
        }
    }
    
    //Alert Message Checking
    func MyAlerts(userMessage:String){
        
        let myAlert = UIAlertController(title:"Alert!", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
        myAlert.view.layer.cornerRadius = 25
    }
    
    //Function Checking Email
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
        
    }
    
    func checkLogin() {
        
        username = self.usernameField.text!
        password = self.passwordField.text!
        
        
        pp = password
        uu = username
        print("print>>>\(username)")
        let urlSring = "https://nickgormanacademy.com/soccerSquat/singup/login.php"
        let parame:[String:String] = ["user": username, "pass": password]
        Alamofire.request(.GET,urlSring, parameters: parame ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    let uid = value["uid"] as? String
                    let detail = value["udetail"] as? String
                    
                    
                    let urlCheckBlock = "https://nickgormanacademy.com/soccerSquat/admin/block/CheckBlock.php" //เช็คว่าถูกบล็อคหรือไม่
                    var parameter:[String:String] = [ "uid":uid!]
                    
                    Alamofire.request(.GET,urlCheckBlock, parameters: parameter ,encoding: .URL).validate()
                        .responseJSON{(response) in
                            switch response.result {
                            case .Success:
                                
                                var JSON = [AnyObject]()
                                JSON = response.result.value as! [AnyObject]!
                                for value in JSON {
                                    
                                    self.numBlock  = (value["unumblock"] as? String)!
                                    self.dateBlock = (value["udateblock"] as? String)!
                                    
                                }
                                
                                if(self.numBlock == "-1" || self.numBlock == "0"){ //-1 ถูกบล็อค
                                    let date = NSDate()
                                    let calendar = NSCalendar.currentCalendar()
                                    let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                                    let year =  components.year
                                    let month = components.month
                                    let day = components.day
                                    var cutDate = [String]()
                                    
                                    print(year)
                                    print(month)
                                    print(day)
                                    
                                    cutDate = self.dateBlock.componentsSeparatedByString("-") //ตัด udateblock เพื่อเอาวันไปเช็ค
                                    
                                    if(Int(cutDate[2])!+1 <= day){ //บวกเพื่อเช็คว่าควบเวลา 1 วันที่บล็อคหรือยัง
                                        print("blok")
                                        let urlReleaseBlock = "https://nickgormanacademy.com/soccerSquat/admin/block/ReleaseBlock.php"
                                        var parameter:[String:String] = [ "uid":uid!]
                                        
                                        Alamofire.request(.GET,urlReleaseBlock, parameters: parameter ,encoding: .URL).validate()
                                            .responseJSON{(response) in
                                                
                                        }
                                        
                                        if(detail == "user"){ //เช็คสถานนะ login
                                            userId = uid!
                                            
                                            //Userdefault
                                            let defaults = NSUserDefaults.standardUserDefaults()
                                            defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                            defaults.synchronize()
                                            
                                            if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                                print("id: \(name)")
                                            }
                                            
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
                                                self.presentViewController(viewController, animated: true, completion: nil)
                                            })
                                            
                                        }else if(detail == "owner"){
                                            userId = uid!
                                            
                                            
                                            let defaults = NSUserDefaults.standardUserDefaults()
                                            defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                            defaults.synchronize()
                                            
                                            
                                            
                                            if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                                print("id: \(name)")
                                            }
                                            
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OwnerTabbar")
                                                self.presentViewController(viewController, animated: true, completion: nil)
                                            })
                                            print("No")
                                            
                                        }
                                        
                                    }else{
                                        print("Unblok")

                                        print(self.dateBlock)
                                        self.MyAlerts("You are blocked from accessing the app for 1 day!")
                                        
                                    }
                                    
                                    
                                    
                                }else{
                                    
                                    
                                    if(detail == "user"){ //เช็คสถานนะ login
                                        userId = uid!
                                        
                                        //Userdefault
                                        let defaults = NSUserDefaults.standardUserDefaults()
                                        defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                        defaults.synchronize()
                                        
                                        if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                            print("id: \(name)")
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
                                            self.presentViewController(viewController, animated: true, completion: nil)
                                        })
                                        
                                    }else if(detail == "owner"){
                                        userId = uid!
                                        
                                        //Userdefault
                                        let defaults = NSUserDefaults.standardUserDefaults()
                                        defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                        defaults.synchronize()
                                        
                                        if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                            print("id: \(name)")
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OwnerTabbar")
                                            self.presentViewController(viewController, animated: true, completion: nil)
                                        })
                                        print("No")
                                        
                                    }else if(detail == "admin"){
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("admin")
                                            self.presentViewController(viewController, animated: true, completion: nil)
                                        })
                                        
                                    }
                                    else{
                                        self.MyAlerts("Your email and password are invalid. Please try again!")
                                    }
                                }
                                
                                print("number1 \(self.numBlock)")
                                
                            case .Failure(let error):
                                print(error)
                            }
                            
                    }
                    
                }
                
        }
        
    }
    
    
    func getFBUserData(){
        Activity().showLoading()
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, gender, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    
                    //                    print(result)
                    
                    self.fb_id = (result.objectForKey("id") as? String)!
                    self.fb_name = (result.objectForKey("name") as? String)!
                    self.fb_email = (result.objectForKey("email") as? String)!
                    self.fb_gender = (result.objectForKey("gender") as? String)!
                    self.fb_picture = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    
                    //Use image's path to create NSData
                    let url:NSURL = NSURL(string : self.fb_picture)!
                    //Now use image to create into NSData format
                    let imageData:NSData = NSData.init(contentsOfURL: url)!
                    let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                    let dataDecoded:NSData = NSData(base64EncodedString: strBase64, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                    self.decodedimage = UIImage(data: dataDecoded)!
                    
                    //Check user database
                    let urlSring = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/selectUser.php"
                    let parame:[String:String] = ["uemail": self.fb_email]
                    Alamofire.request(.GET,urlSring, parameters: parame ,encoding: .URL).validate()
                        .responseJSON{(response) in
                            var JSON = [AnyObject]()
                            
                            switch response.result {
                            case .Success:
                                
                                JSON = response.result.value as! [AnyObject]!
                                for value in JSON {
                                    
                                    self.get_email = (value["uemail_fb"] as? String)!
                                    
                                }
                                print(self.get_email)
                                
                                if self.get_email == "" {
                                    Activity().hideLoading()
                                    print("data nil")
                                    
                                    let alertController = UIAlertController(title: "Choose Mode", message: "Please your choose mode.", preferredStyle: .ActionSheet)
                                    
                                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in}
                                    
                                    
                                    let ownerAction = UIAlertAction(title: "Owner", style: .Default) { action in
                                        
                                        self.fb_status = "owner"
                                        self.fb_block = "3"
                                        self.uploadFacebookUser()
                                        
                                    }
                                    
                                    let playerAction = UIAlertAction(title: "Player", style: .Default) { action in
                                        
                                        self.fb_status = "user"
                                        self.fb_block = "3"
                                        self.uploadFacebookUser()
                                        
                                    }
                                    
                                    alertController.addAction(ownerAction)
                                    alertController.addAction(playerAction)
                                    alertController.addAction(cancelAction)
                                    self.presentViewController(alertController, animated: true) {}
                                    
                                    alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
                                    alertController.view.layer.cornerRadius = 25
                                    
                                    
                                    
                                }else {
                                    
                                    
                                    JSON = response.result.value as! [AnyObject]!
                                    for value in JSON {
                                        
                                        self.get_uid = (value["uid"] as? String)!
                                        self.get_detail = (value["udetail"] as? String)!
                                        self.get_email = (value["uemail"] as? String)!
                                        self.get_email_fb = (value["uemail_fb"] as? String)!
                                        
                                    }
                                    Activity().hideLoading()
                                    if self.get_email_fb == "" {
                                        
//                                        let alertController = UIAlertController(title: "Synchronize", message: "Do you want to retrieve name, picture and gender from Facebook?", preferredStyle: .ActionSheet)
//                                        
//                                        let cancelAction = UIAlertAction(title: "Not", style: .Cancel) { action in
                                        
                                            if self.get_detail == "owner" {
                                                userId = self.get_uid
                                                
                                                //Userdefault
                                                let defaults = NSUserDefaults.standardUserDefaults()
                                                defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                                defaults.synchronize()
                                                
                                                if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                                    print("id: \(name)")
                                                }
                                                
                                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OwnerTabbar")
                                                    self.presentViewController(viewController, animated: true, completion: nil)
                                                })
                                                
                                            }else if self.get_detail == "user" {
                                                userId = self.get_uid
                                                
                                                //Userdefault
                                                let defaults = NSUserDefaults.standardUserDefaults()
                                                defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                                defaults.synchronize()
                                                
                                                if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                                    print("id: \(name)")
                                                }
                                                
                                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
                                                    self.presentViewController(viewController, animated: true, completion: nil)
                                                })
                                                
                                                
                                            }else if self.get_detail == "admin" {
                                                userId = self.get_uid
                                                
                                                //Userdefault
                                                let defaults = NSUserDefaults.standardUserDefaults()
                                                defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                                defaults.synchronize()
                                                
                                                if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                                    print("id: \(name)")
                                                }
                                                
                                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("admin")
                                                    self.presentViewController(viewController, animated: true, completion: nil)
                                                })
                                                
                                            }else {
                                                
                                                self.MyAlerts("Login Failed!")
                                            }
//                                            
//                                        }
//                                        
//                                        let SyncAction = UIAlertAction(title: "Sync", style: .Default) { action in
//                                            
//                                            //....
//                                            
//                                        }
//                                        
//                                        
//                                        alertController.addAction(SyncAction)
//                                        alertController.addAction(cancelAction)
//                                        self.presentViewController(alertController, animated: true) {}
//                                        
//                                        alertController.view.tintColor = UIColor(red:0.13, green:0.81, blue:0.68, alpha:1.0)
//                                        alertController.view.layer.cornerRadius = 25
//                                        
//                                        
                                        
                                        
                                    }else {
                                        Activity().showLoading()
                                        
                                        if self.get_detail == "owner" {
                                            userId = self.get_uid
                                            
                                            //Userdefault
                                            let defaults = NSUserDefaults.standardUserDefaults()
                                            defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                            defaults.synchronize()
                                            
                                            if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                                print("id: \(name)")
                                            }
                                            Activity().hideLoading()
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OwnerTabbar")
                                                self.presentViewController(viewController, animated: true, completion: nil)
                                            })
                                            
                                        }else if self.get_detail == "user" {
                                            userId = self.get_uid
                                            
                                            //Userdefault
                                            let defaults = NSUserDefaults.standardUserDefaults()
                                            defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                            defaults.synchronize()
                                            
                                            if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                                print("id: \(name)")
                                            }
                                            Activity().hideLoading()
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar")
                                                self.presentViewController(viewController, animated: true, completion: nil)
                                            })
                                            
                                            
                                        }else if self.get_detail == "admin" {
                                            userId = self.get_uid
                                            
                                            //Userdefault
                                            let defaults = NSUserDefaults.standardUserDefaults()
                                            defaults.setObject(userId, forKey: self.userNameKeyConstant)
                                            defaults.synchronize()
                                            
                                            if let name = defaults.stringForKey(self.userNameKeyConstant) {
                                                print("id: \(name)")
                                            }
                                            Activity().hideLoading()
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("admin")
                                                self.presentViewController(viewController, animated: true, completion: nil)
                                            })
                                            
                                        }else {
                                            Activity().hideLoading()
                                            self.MyAlerts("Login Failed!")
                                        }
                                        
                                        
                                    }
                                }
                                
                                
                            case .Failure(let error):
                                print(error.localizedDescription)
                            }
                            
                    }
                    
                }else {
                    
                    print(error.localizedDescription)
                    
                }
            })
        }
    }
    
    // no data in server
    func uploadFacebookUser() {
        
        Activity().showLoading()
        let urlSring = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/CreateUserFB.php"
        let parame:[String:String] = ["name": self.fb_name, "email": "", "status": self.fb_status, "emailfb":self.fb_email, "gender":self.fb_gender, "block": self.fb_block]
        
        
        Alamofire.upload(.POST, urlSring,headers: parame ,multipartFormData: {multipartFormData in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(self.decodedimage!,0.4)! ,name: "file", fileName:"file.JPEG", mimeType: "owner/FieldManager/")
            
            
            for (key, value) in parame {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
            }
            
            } ,  encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { (response) in
                        
                        print("Upload Success")
                        Activity().hideLoading()
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    Activity().hideLoading()
                }
                
        })
        
        
    }
    
}



  