//
//  Book.swift
//  Project2
//
//  Created by toffee on 7/2/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class Book: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var stopTime: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnBook: UIButton!
    
    
    var pickStart = [String]()
    var pickStop = [String]()
    
    var keyText = ""
    var memberFieldId = ""
    
    var hour : Double = 0
    var price = ""
    var timeAmount = 0
    var pledge = 0
    var totalPrice = 0
    var duplicateTime = ""
    
    var tStart = ""
    var tStop = ""
    var  addTStart = [String]()
    var  addTStop = [String]()
    
    var timeIn = ""
    var timeOut = ""
    
    var fid = ""
    var chackKey = "" //คีย์ส่งถูกส่งไปยังหน้ามัดจำเพื่อเช็คว่า ค่าที่ส่งมา มาจากหน้าจอง หรือ หน้า Hitory
    
    var pickerViewStart = UIPickerView()
    var pickerViewStop = UIPickerView()
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.openTime()
        self.listTime()
        self.btnBook.layer.cornerRadius = 12
       
        startTime.addTarget(self, action: "start:", forControlEvents: UIControlEvents.TouchDown)
        stopTime.addTarget(self, action: "stop:", forControlEvents: UIControlEvents.TouchDown)

        // Do any additional setup after loading the view.
    }
    
    
    func listTime(){
        
        let urlTimeAll = "https://nickgormanacademy.com/soccerSquat/booking/TimeBookAll.php"
        var parame:[String:String] = ["mnf_id": memberFieldId]
        Alamofire.request(.GET,urlTimeAll,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.tStart  = (value["bstartime"] as? String)!
                        self.tStop  = (value["bstoptime"] as? String)!
                      
                        self.addTStart.append(self.tStart)
                        self.addTStop.append(self.tStop)
                 
                        
                    }
                    self.tableview.reloadData()
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }
        
    }
    
    func openTime(){
        
        var cutStingTimeIn = [String]()
        var cutStingTimeOut = [String]()
        
        var timeIn = ""
        var timeOut = ""
        let urlOpenTime = "https://nickgormanacademy.com/soccerSquat/booking/OpenTime.php"
        var parame:[String:String] = ["mbfId": memberFieldId]
        Alamofire.request(.GET,urlOpenTime,parameters: parame,encoding: .URL).validate()
            .responseJSON{(response) in
                
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.timeIn  = (value["ftime_in"] as? String)!
                        self.timeOut  = (value["ftime_out"] as? String)!
                        self.fid  = (value["fid"] as? String)!
                        
                        
                    }
//                print("in = \(self.timeIn)")
//                print("Out = \(self.timeOut)")
                    
                cutStingTimeIn = self.timeIn.componentsSeparatedByString(":")
                cutStingTimeOut = self.timeOut.componentsSeparatedByString(":")
                timeIn = cutStingTimeIn[0]
                timeOut = cutStingTimeOut[0]
                print("in1 = \(Int(timeIn)!)")
                print("in2 = \(Int(timeOut)! )")
                    if(timeIn < timeOut){
                        for i in Int(timeIn)! ... Int(timeOut)! {
                            
                            self.pickStart.append(String(i) + ".00")
                            self.pickStop.append(String(i) + ".00")
                            
                        }
                    
                    }else if(timeIn > timeOut){
                        let num:Int = ((23 - Int(timeIn)!) + 2) + Int(timeOut)!
                        var sumStart:Int = Int(timeIn)!
                        //var sumStop:Int = Int(timeOut)!
                        var setTime:Int = sumStart
                        var midnight:Int = 0

                        
                        var i = 1
                        while i <= num {
                            
                            if(setTime >= 24){
                                
                                self.pickStart.append(String(midnight) + ".00")
                                self.pickStop.append(String(midnight) + ".00")
                                midnight = midnight+1
                            }else{
                                self.pickStart.append(String(setTime) + ".00")
                                self.pickStop.append(String(setTime) + ".00")
                            }
                            
                            
                            setTime = setTime + 1
                            
                            i = i + 1
                        }
                    
                    }
                
               
                case .Failure(let error):
                    print(error)
                }
                
                
                
        }
    
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return addTStart.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? BookCell
        
        cell?.startTime.text = addTStart[indexPath.row]
        cell?.stopTime.text = addTStop[indexPath.row]
        
        return cell!
            
        
    }
    
    
    
    func start(textField: UITextField) {
        
        pickerViewStart.delegate = self
        pickerViewStart.dataSource = self
        startTime.inputView = pickerViewStart
        keyText = "0"
    }
    func stop(textField: UITextField) {
        print("xxx???")
        pickerViewStop.delegate = self
        pickerViewStop.dataSource = self
        stopTime.inputView = pickerViewStop
        keyText = "1"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickStart.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickStart[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(keyText == "0"){
            
             startTime.text = pickStart[row]
        }else if (keyText == "1"){
           
             stopTime.text = pickStop[row]
        }
        
    
       
       
    }
    
    @IBAction func book(sender: AnyObject) {
        let numberStart = self.startTime.text
        let numberStop = self.stopTime.text
        self.duplicateTime = ""
        
        if(numberStart == "" || numberStop == ""){
            var alert = UIAlertView(title: "Error", message: "Please Enter time.", delegate: self, cancelButtonTitle: "OK")
            alert.show()

        
        }else{
            
            
            if(Int(Double(numberStop!)!) <=  Int(Double(numberStart!)!)){//กรณีจองเลยเที่ยงคืน
                
                if(Int(Double(numberStop!)!) > Int(Double(pickStop[pickStop.count - 1])!)){
                    var alert = UIAlertView(title: "Error", message: "\(Int(Double(pickStop[pickStop.count - 1])!))", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
                else{
                    print("h1")
                    self.hour = Double(numberStart!)! - Double(numberStop!)!
                    
                    self.timeAmount = Int(self.hour)
                    self.totalPrice = Int(self.price)! * self.timeAmount
                    self.pledge = self.totalPrice/2
                    
                    
                    let urlTimeAll = "https://nickgormanacademy.com/soccerSquat/booking/TimeBookAll.php"
                    var urlparame:[String:String] = ["mnf_id": memberFieldId]
                    Alamofire.request(.GET,urlTimeAll,parameters: urlparame,encoding: .URL).validate()
                        .responseJSON{(response) in
                            print("a1")
                            switch response.result {
                            case .Success:
                                
                                var JSON = [AnyObject]()
                                JSON = response.result.value as! [AnyObject]!
                                for value in JSON {
                                    
                                    self.tStart  = (value["bstartime"] as? String)!
                                    self.tStop  = (value["bstoptime"] as? String)!
                                    
                                    if(  Int(Double(numberStart!)!) == Int(Double(self.tStart)!) && Int(Double(numberStop!)!) == Int(Double(self.tStop)!)  ){
                                        print("oo")
                                        self.duplicateTime = "duplicate"
                                        
                                    }
                                    else if(  Int(Double(numberStart!)!) < Int(Double(self.tStart)!) && Int(Double(numberStop!)!) < Int(Double(self.tStop)!)  ){
                                        print("aa")
                                        self.duplicateTime = "duplicate"
                                        
                                    }
                                        
//                                    else if(  Int(Double(numberStart!)!) > Int(Double(self.tStart)!) && Int(Double(numberStop!)!) < Int(Double(self.tStop)!)  ){
//                                        print("bb")
//                                        self.duplicateTime = "duplicate"
//                                        
//                                    }
                                    
                                }
                                if( self.duplicateTime == "duplicate"){
                                    
                                    var alert = UIAlertView(title: "Error", message: "Duplicate Time", delegate: self, cancelButtonTitle: "OK")
                                    alert.show()
                                    
                                }else if(self.duplicateTime != "duplicate"){
                                    
                                    // Create the alert controller
                                    let alertController = UIAlertController(title: "Confirm Success", message: "you want to Book ?", preferredStyle: .Alert)
                                    // Create the actions
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                                        UIAlertAction in
                                        let url = "https://nickgormanacademy.com/soccerSquat/booking/book.php"
                                        var parame:[String:String] = ["starttime": numberStart!, "stoptime":numberStop!, "timeamount":String(self.timeAmount), "price":String(self.totalPrice), "pledge":String(self.pledge), "uid":userId, "mnf_id":self.memberFieldId]
                                        Alamofire.request(.GET,url,parameters: parame,encoding: .URL).validate()
                                            .responseJSON{(response) in
                                                
                                        }
                                        self.performSegueWithIdentifier("paypledge", sender: self)
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
                                
                            case .Failure(let error):
                                print(error)
                            }
                            
                    }
                
                }
                
                
                
                
//                var alert = UIAlertView(title: "Error", message: "Please Check time.", delegate: self, cancelButtonTitle: "OK")
//                alert.show()
                
            }
            else{
                print("h2")
                self.hour = Double(numberStop!)! - Double(numberStart!)!
                
                self.timeAmount = Int(self.hour)
                self.totalPrice = Int(self.price)! * self.timeAmount
                self.pledge = self.totalPrice/2
                
                
                let urlTimeAll = "https://nickgormanacademy.com/soccerSquat/booking/TimeBookAll.php"
                var urlparame:[String:String] = ["mnf_id": memberFieldId]
                Alamofire.request(.GET,urlTimeAll,parameters: urlparame,encoding: .URL).validate()
                    .responseJSON{(response) in
                        
                        switch response.result {
                        case .Success:
                            
                            var JSON = [AnyObject]()
                            JSON = response.result.value as! [AnyObject]!
                            for value in JSON {
                                
                                self.tStart  = (value["bstartime"] as? String)!
                                self.tStop  = (value["bstoptime"] as? String)!
                                
                                
                                 if(Int(Double(self.tStop)!) < Int(Double(self.tStart)!)){//เช็คก่อนว่าเวลาที่มีคนจองแล้ว stop มากกว่า start หรือไม่
                                    if(  Int(Double(numberStart!)!) >= 0 && Int(Double(numberStop!)!) < Int(Double(self.tStop)!)  ){
                                        print("xx")
                                        self.duplicateTime = "duplicate"
                                        
                                    }
                                    
                                 }else{
                                    
                                    if(  Int(Double(numberStart!)!) > Int(Double(self.tStart)!) && Int(Double(numberStart!)!) < Int(Double(self.tStop)!)  ){
                                        print("00")
                                        self.duplicateTime = "duplicate"
                                        
                                    }
                                    else if(  Int(Double(numberStop!)!) > Int(Double(self.tStart)!) && Int(Double(numberStop!)!) <=
                                        Int(Double(self.tStop)!)  ){
                                        self.duplicateTime = "duplicate"
                                        print("11")
                                    }
                                    else if(  Int(Double(self.tStart)!) > Int(Double(numberStart!)!) && Int(Double(self.tStart)!) < Int(Double(numberStop!)!)){
                                        print("22")
                                        self.duplicateTime = "duplicate"
                                        
                                    }
                                    else if(  Int(Double(self.tStop)!) > Int(Double(numberStart!)!) && Int(Double(self.tStop)!) <= Int(Double(numberStop!)!)){
                                        print("33")
                                        self.duplicateTime = "duplicate"
                                        
                                    }

                                }
                                
                            }
                            if( self.duplicateTime == "duplicate"){
                                
                                var alert = UIAlertView(title: "Error", message: "Duplicate Time", delegate: self, cancelButtonTitle: "OK")
                                alert.show()
                                
                            }else if(self.duplicateTime != "duplicate"){
                                // Create the alert controller
                                let alertController = UIAlertController(title: "Confirm Success", message: "you want to Book ?", preferredStyle: .Alert)
                                // Create the actions
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                                    UIAlertAction in
                                    let url = "https://nickgormanacademy.com/soccerSquat/booking/book.php"
                                    var parame:[String:String] = ["starttime": numberStart!, "stoptime":numberStop!, "timeamount":String(self.timeAmount), "price":String(self.totalPrice), "pledge":String(self.pledge), "uid":userId, "mnf_id":self.memberFieldId]
                                    Alamofire.request(.GET,url,parameters: parame,encoding: .URL).validate()
                                        .responseJSON{(response) in
                                            
                                    }
                                   self.performSegueWithIdentifier("paypledge", sender: self)
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
                     
                        case .Failure(let error):
                            print(error)
                        }
                       
                }
                
            }
        
        }
        
    }

    

}
