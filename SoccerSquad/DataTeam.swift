//
//  DataTeam.swift
//  ParseDemo
//
//  Created by toffee on 11/4/2559 BE.
//  Copyright © 2559 abearablecode. All rights reserved.
//

import UIKit
import Alamofire

let shard = DataTeam()


class DataTeam: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    @IBOutlet var NameTeam: UILabel!
    @IBOutlet weak var head: UILabel!
    @IBOutlet weak var detalTeam: UITextView!
   
    @IBOutlet weak var tImage: UIImageView!
   
    
    @IBOutlet weak var nameHead: UILabel!
    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //let mmm = CreateTeam()
    var name:String = "" //ส่งมาจาก myTeam
    var _nameHead:String = ""
    var id_team :String! //ส่งมาจาก myTeam
    var uid :String! //ส่งมาจาก myTeam
   
    var addUname = [String]()
    var addStatusmemberteam = [String]()
    var addUidMember = [String]()
    var memberCount = [String]()
    var readName  = ""
    var readStatus  = ""
    var uidMember = ""
    var  detailTeam = ""
    var index = 0
    var  checkLength = 0
    var idMember = ""
    var nameImage = ""
    
    var key = "" //ค่าจะถูกส่งมา join event  เพื่อที่จะเช็คเงื่อนไขหลังจากมีการกดปุ่ม join เข้าม่
    var amount = "" //ค่าจะถูกส่งมา จำนวณคนที่รับ
    var playerId = ""
    
    var refresh = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    
    let urlSring = "https://nickgormanacademy.com/soccerSquat/team/haedTeam.php"
    let urlMember = "https://nickgormanacademy.com/soccerSquat/team/memberTeam.php"
    
   
    @IBAction func unwindToDataTeam(segue: UIStoryboardSegue) {
        
        self.viewDidLoad()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let parame1:[String:String] = ["tid": id_team ]
        let parame2:[String:String] = ["tid": id_team ]
        let parame3:[String:String] = ["playerid": self.playerId , "amount":self.amount]
        NameTeam.text = name
        self.addStatusmemberteam = []
        self.addUname = []
        self.memberCount = []
        //self.navigationItem.setHidesBackButton(true, animated:true);
        print("toffee")
       
        
        Alamofire.request(.GET, urlSring, parameters: parame1, encoding: .URL).validate()//ดึงข้อมูลหัวหน้าทีม
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                   
                    self._nameHead  = (value["uname"] as? String)!
                    self.detailTeam = (value["tdetail"] as? String)!
                   

                    
                }
                self.nameHead.text = self._nameHead
                self.detalTeam.text = self.detailTeam
            }
        
        Alamofire.request(.GET, urlMember, parameters: parame2, encoding: .URL).validate() //ดึงข้อมูลสมาชิกในทีม
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.readName  = (value["uname"] as? String)!
                    self.readStatus  = (value["statusmemberteam"] as? String)!
                    self.uidMember  = (value["uid"] as? String)!
                    
                    self.addUname.append(self.readName)
                    self.addStatusmemberteam.append(self.readStatus)
                    self.addUidMember.append(self.uidMember)
                    
                    if(self.readStatus == "YES"){ //เช็คคนที่ตอบยืนยันเข้าร่วมทีม
                        self.memberCount.append(self.readStatus)
                    }
                    
                }
                
                let now = NSDate()
                
                let updateString = "Refresh... " + self.dateFormatter.stringFromDate(now)
                self.refresh.attributedTitle = NSAttributedString(string: updateString)
                
                self.refresh.addTarget(self, action: #selector(self.viewDidLoad), forControlEvents: UIControlEvents.ValueChanged)
                
                self.refresh.endRefreshing()
                self.tableView.addSubview(self.refresh)
                
                self.nameHead.text = self._nameHead
                print("name = \(self.addUname)")
                self.tableView.reloadData()

        }
        print("userId = \(userId)")
          print("uid = \(uid)")
        
        if(userId == uid){ //สร้าง button delteam และ editteam
            let btn: UIButton = UIButton(frame: CGRectMake(260, 70, 30, 30))
            btn.setImage(UIImage(named: "deleteTeme"), forState: UIControlState.Normal)
            btn.addTarget(self, action: "buttonActionDel:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.tag = 1
            self.view.addSubview(btn)
            
            
            
            let btnEdit: UIButton = UIButton(frame: CGRectMake(220, 70, 30, 30))
            btnEdit.setImage(UIImage(named: "EditTeme"), forState: UIControlState.Normal)
            btnEdit.addTarget(self, action: "editTeam:", forControlEvents: UIControlEvents.TouchUpInside)
            btnEdit.tag = 2
            self.view.addSubview(btnEdit)

            
        }
        if(userId != uid){
            
            let btnOutTeam: UIButton = UIButton(frame: CGRectMake(120, 485, 80, 30))
            //btnOutTeam.backgroundColor = .greenColor()
            btnOutTeam.backgroundColor = UIColor(red:1.00, green:0.45, blue:0.45, alpha:1.0)
            btnOutTeam.layer.cornerRadius = 12
            btnOutTeam.setTitle("Out", forState: .Normal)
            btnOutTeam.addTarget(self, action: "buttonOutTeam:", forControlEvents: UIControlEvents.TouchUpInside)
            btnOutTeam.tag = 3
            self.view.addSubview(btnOutTeam)
        
        }
        
        if (self.key == "chackJoinEvent") { //จะเช็คจำนวนคนว่าจอยเข้ามาครบหรือยัง จาก Event
            var complete = ""
            let urlChackAmount = "https://nickgormanacademy.com/soccerSquat/team/ChackAmountJoin.php"
            
            Alamofire.request(.GET, urlChackAmount, parameters: parame3, encoding: .URL).validate()
                .responseJSON{(response) in
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        complete  = (value["fully"] as? String)!
                    }
                    print("complete = \(complete)")
            }
        }
        
        self.getDataTeam()
        
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.checkLength = addUname.count+1
        print("number = \(addUname.count)")
        number.text = String(memberCount.count)
        return addUname.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! dataTeamCell
       
        
        if(userId == uid){ let btn: UIButton = UIButton(frame: CGRectMake(170, 5, 30, 30)) //สร้างปุ่ม DeleteMember ในกรณีที่เป็นหัวหน้าทีม
            cell.listName.text = self.addUname[indexPath.row]
            cell.wait.text = self.addStatusmemberteam[indexPath.row]
            btn.setImage(UIImage(named: "Booking"), forState: UIControlState.Normal)
            btn.tag = indexPath.row
            btn.addTarget(self, action: "buttonDelMember:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(btn)
        }
        else{
            cell.listName.text = self.addUname[indexPath.row]
            cell.wait.text = self.addStatusmemberteam[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
       
        self.idMember = addUidMember[indexPath.row]
        self.performSegueWithIdentifier("doGetUser", sender: self)
       
    }
    
    func buttonOutTeam(sender: UIButton) {  //ออกจากทีม
    
        // Create the alert controller
        let alertController = UIAlertController(title: "Confirm ", message: "you want to team out ?", preferredStyle: .Alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            let urlDelMember = "https://nickgormanacademy.com/soccerSquat/team/deleteMember.php"
            let parame3:[String:String] = ["tid": self.id_team ,"uid":userId ]
            Alamofire.request(.GET, urlDelMember, parameters: parame3, encoding: .URL).validate()
                .responseJSON{(response) in
                    
            }
            self.performSegueWithIdentifier("back", sender: self)

            
            //self.refresh()
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
    
    
    func buttonDelMember(sender: UIButton) {
         // Create the alert controller
        let alertController = UIAlertController(title: "Confirm Delete", message: "you want to Delete ?", preferredStyle: .Alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            let urlDelMember = "https://nickgormanacademy.com/soccerSquat/team/deleteMember.php"
            let parame3:[String:String] = ["tid": self.id_team ,"uid":self.addUidMember[sender.tag] ]
            Alamofire.request(.GET, urlDelMember, parameters: parame3, encoding: .URL).validate()
                .responseJSON{(response) in
                    
            }
            
            var alert = UIAlertView(title: "Confirm", message: "Delete Success...", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
            self.viewDidLoad()
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
    
    func buttonActionDel(sender: UIButton) { //DeleteTeam
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Confirm Delete", message: "you want to Delete ?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let parame3:[String:String] = ["tid": self.id_team ]
            let urlSring = "https://nickgormanacademy.com/soccerSquat/team/deleteTeam.php"
            Alamofire.request(.GET,urlSring ,parameters: parame3 ,encoding: .URL).validate()
                .responseJSON{(response) in
                    
            }
            var alert = UIAlertView(title: "Confirm", message: "Delete Success...", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("myTeam")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            
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
    
    
    func editTeam(sender: UIButton){
        
        performSegueWithIdentifier("editteam", sender: self)
    
    }
    
    
    @IBAction func buttonInvilt(sender: AnyObject) {
        let urlUserAll = "https://nickgormanacademy.com/soccerSquat/user/selectUserAll.php"
        Alamofire.request(.GET, urlUserAll, encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                print("numberInvilt = \(JSON.count)")
                if(JSON.count == self.checkLength){
                    var alert = UIAlertView(title: "xxxxx", message: "xxxxxx", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
                else{
                    self.performSegueWithIdentifier("segue_shearch", sender: sender)
                }
                
                }
        
    }
   
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segue_shearch") {
            let DestViewController = segue.destinationViewController as! SearchUser_Tame
            //let DestViewController = navController.topViewController as! SearchUser_Tame
          
            DestViewController.idTeam = self.id_team
            DestViewController.uid = uid

        }
        if(segue.identifier == "doGetUser"){
            
            //let navController = segue.destinationViewController as! UINavigationController
            //let DestViewController = navController.topViewController as! dataUser
         let navController = segue.destinationViewController as! dataUser
            navController.uid = idMember

        
        }
        
        if(segue.identifier == "editteam"){
            let navController = segue.destinationViewController as! EditTeam
            navController.tid = self.id_team
        
        }
        
        
        
    }
    
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static var instance : DataTeam!
    
    class func shared() -> DataTeam {
        self.instance = (self.instance ?? DataTeam())
        return self.instance
    }
    
    
    func getDataTeam() {
        let parame4:[String:String] = ["tid": self.id_team ]
        let urlSring = "https://nickgormanacademy.com/soccerSquat/team/dataTeam.php"
        Alamofire.request(.GET,urlSring ,parameters: parame4 ,encoding: .URL).validate()
            .responseJSON{(response) in
                
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    self.nameImage  = (value["timage"] as? String)!
                    var urlImage = "https://nickgormanacademy.com/soccerSquat/image/" + self.nameImage

                    self.getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
                        self.tImage.image = image
                        self.tImage.contentMode = .ScaleAspectFill
                        //self.tImage.layer.borderWidth = 1.0
                        self.tImage.layer.masksToBounds = false
                        self.tImage.layer.cornerRadius = self.tImage.frame.size.height/2
                        self.tImage.clipsToBounds = true
                    }

                }
                
                
        }
    }
    
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }
    
    
    
    
    
    
}
