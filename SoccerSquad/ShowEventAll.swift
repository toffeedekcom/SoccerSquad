  //
  //  ShowEventAll.swift
  //  Project2
  //
  //  Created by toffee on 6/21/2560 BE.
  //  Copyright © 2560 Scott. All rights reserved.
  //
  
  import UIKit
  import Alamofire
  
  class ShowEventAll: UITableViewController {
    
    
    @IBOutlet weak var segmemtedContro: UISegmentedControl!
    var date = ""
    var nameEvent = ""
    var pid = ""
    var nameField = ""
    var tourId = ""
    var segmemted = ""
    var playerId = ""
    var amount = ""
    
    var addDate = [String]()
    var addNameEvent = [String]()
    var addPid = [String]()
    var addNameField = [String]()
    var addTourId = [String]()
    var addAmount = [String]()
    var timer  = NSTimer()
    var num = 0
    var countNotification = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNameField = []
        self.addNameEvent = []
        self.addDate = []
       
        
        self.doEvent()
        
        
    }
    
    
    @IBAction func segmemtedEvent(sender: AnyObject) {
        switch segmemtedContro.selectedSegmentIndex
        {
        case 0:
            
            var chackData = ""
            self.segmemted = "0"
            self.addNameField = []
            self.addNameEvent = []
            self.addDate = []
            self.addPid = []
            var urlSring = "https://nickgormanacademy.com/soccerSquat/event/chackEvent.php"
            var parameter:[String:String] = [ "uid":userId, "segmemted":"0"]
            Alamofire.request(.GET,urlSring ,parameters: parameter, encoding: .URL).validate()
                .responseJSON{(response) in
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    
                    
                    
                    
                    for value in JSON {
                        
                        chackData  = (value["chack"] as? String)!
                        if(chackData == "1"){
                            print(chackData)
                            var urlEventAll = "https://nickgormanacademy.com/soccerSquat/event/EventAll.php"
                            var parameter:[String:String] = [ "uid":userId]
                            
                            Alamofire.request(.GET,urlEventAll ,parameters: parameter, encoding: .URL).validate()
                                .responseJSON{(response) in
                                    
                                    
                                    switch response.result {
                                    case .Success:
                                        
                                        var JSON = [AnyObject]()
                                        JSON = response.result.value as! [AnyObject]!
                                        
                                        for value in JSON {
                                            self.date  = (value["playerdate"] as? String)!
                                            self.nameEvent  = (value["playername"] as? String)!
                                            self.pid  = (value["playerid"] as? String)!
                                            self.nameField = (value["fname"] as? String)!
                                            
                                            
                                            self.addDate.append(self.date)
                                            self.addNameEvent.append(self.nameEvent)
                                            self.addPid.append(self.pid)
                                            self.addNameField.append(self.nameField)
                                            
                                        }
                                        self.tableView.reloadData()
                                        
                                    case .Failure(let error):
                                        print(error)
                                    }
                                    
                                    
                            }
                        }
                        else{
                            //print(chackData)
                        }
                        
                        
                        
                        
                    }
                    print(self.addNameEvent)
                    
            }
            self.tableView.reloadData()
            
        case 1:
            //self.doEvent()
            var chackData = ""
            self.segmemted = "1"
            self.addNameField = []
            self.addNameEvent = []
            self.addDate = []
            self.addPid = []
            var urlSegment = "https://nickgormanacademy.com/soccerSquat/event/chackEvent.php"
            var parameter:[String:String] = [ "uid":userId , "segmemted":"1"]
            Alamofire.request(.GET,urlSegment ,parameters: parameter, encoding: .URL).validate()
                .responseJSON{(response) in
                    
                    switch response.result {// เช็คว่ามีข้อมูลไหม
                    case .Success:
                        var JSON = [AnyObject]()
                        JSON = response.result.value as! [AnyObject]!
                        
                        for value in JSON {
                            self.date  = (value["playerdate"] as? String)!
                            self.nameEvent  = (value["playername"] as? String)!
                            self.nameField  = (value["fname"] as? String)!
                            self.pid  = (value["playerid"] as? String)!
                            
                            self.addDate.append(self.date)
                            self.addNameEvent.append(self.nameEvent)
                            self.addNameField.append(self.nameField)
                            self.addPid.append(self.pid)
                            
                        }
                        
                        self.tableView.reloadData()
                        print(self.addNameEvent)
                        
                        
                    case .Failure(let error):
                        print(error)
                    }
                    
                    
            }
            self.tableView.reloadData()
            
        case 2:
            print("")
            //self.doEvent()
            var chackData = ""
            self.segmemted = "2"
            self.addNameField = []
            self.addNameEvent = []
            self.addDate = []
            self.addPid = []
            var urlSegment = "https://nickgormanacademy.com/soccerSquat/event/TournamentEvent.php"
            var parameter:[String:String] = [ "type":"TournamentAll","tournamentId":"-1"]
            Alamofire.request(.GET,urlSegment,parameters: parameter , encoding: .URL).validate()
                .responseJSON{(response) in
                    
                    switch response.result {// เช็คว่ามีข้อมูลไหม
                    case .Success:
                        var JSON = [AnyObject]()
                        JSON = response.result.value as! [AnyObject]!
                        
                        for value in JSON {
                            self.date  = (value["tour_date"] as? String)!
                            self.nameEvent  = (value["tourname"] as? String)!
                            self.nameField  = (value["fname"] as? String)!
                            self.tourId = (value["tourid"] as? String)!
                            self.amount = (value["tour_count"] as? String)!
                            
                            
                            self.addDate.append(self.date)
                            self.addNameEvent.append(self.nameEvent)
                            self.addNameField.append(self.nameField)
                            self.addPid.append(self.tourId)
                            self.addAmount.append(self.amount)
                            
                        }
                        
                        self.tableView.reloadData()
                        print(self.addNameEvent)
                        
                        
                    case .Failure(let error):
                        print(error)
                    }
                    
                    
                    
                    
            }
            self.tableView.reloadData()
            
        default:
            break;
            
        }
    }
    
    
    @IBAction func AddEvent(sender: AnyObject) {
        performSegueWithIdentifier("addevent", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.addNameEvent.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? ShowEventAllCell
        
        cell?.date.text = self.addDate[indexPath.row]
        cell?.nameEvent.text = self.addNameEvent[indexPath.row]
        cell?.detail.text = self.addNameField[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(self.segmemted == "0"){
            self.playerId = self.addPid[indexPath.row]
            performSegueWithIdentifier("allevent", sender: self)
        }
        else if(self.segmemted == "1"){
            self.playerId = self.addPid[indexPath.row]
            
            performSegueWithIdentifier("myevent", sender: self)
        }
        else if(self.segmemted == "2"){
            self.playerId = self.addPid[indexPath.row]
            self.amount = self.addAmount[indexPath.row]
            
            performSegueWithIdentifier("tournament", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "allevent") {
            let DestViewController = segue.destinationViewController as! JoinEventViewController
            DestViewController.playerId = playerId
            
        }
        else if (segue.identifier == "myevent") {
            let DestViewController = segue.destinationViewController as! MyEventViewController
            DestViewController.playerId = playerId
            
            
        }
        else if (segue.identifier == "tournament") {
            print("tourment")
            let DestViewController = segue.destinationViewController as! TournamentEvent
            DestViewController.tournamentId = playerId
            DestViewController.amount = self.amount
            
        }
        
        
        
        
        
        
    }
    
    func doEvent() {
        var chackData = ""
        print("zzzzz")
        self.segmemted = "0"
        self.addNameField = []
        self.addNameEvent = []
        self.addDate = []
        var urlSring = "https://nickgormanacademy.com/soccerSquat/event/chackEvent.php"
        var parameter:[String:String] = [ "uid":userId, "segmemted":"0"]
        Alamofire.request(.GET,urlSring ,parameters: parameter, encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                
                
                
                
                for value in JSON {
                    
                    chackData  = (value["chack"] as? String)!
                    if(chackData == "1"){
                        print(chackData)
                        var urlEventAll = "https://nickgormanacademy.com/soccerSquat/event/EventAll.php"
                        var parameter:[String:String] = [ "uid":userId]
                        
                        Alamofire.request(.GET,urlEventAll ,parameters: parameter, encoding: .URL).validate()
                            .responseJSON{(response) in
                                
                                
                                switch response.result {
                                case .Success:
                                    
                                    var JSON = [AnyObject]()
                                    JSON = response.result.value as! [AnyObject]!
                                    for value in JSON {
                                        self.date  = (value["playerdate"] as? String)!
                                        self.nameEvent  = (value["playername"] as? String)!
                                        self.nameField  = (value["fname"] as? String)!
                                        self.pid  = (value["playerid"] as? String)!
                                        
                                        self.addDate.append(self.date)
                                        self.addNameEvent.append(self.nameEvent)
                                        self.addNameField.append(self.nameField)
                                        self.addPid.append(self.pid)
                                        
                                        
                                    }
                                    self.tableView.reloadData()
                                case .Failure(let error):
                                    print(error)
                                }
                                
                                
                                
                                
                        }
                    }
                    else{
                        //print(chackData)
                    }
                    
                    
                    
                    
                }
                
                
        }
        
        
    }
    
  }
  
  
  
  
  
  
  
