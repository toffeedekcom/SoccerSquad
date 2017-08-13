//
//  Block.swift
//  Project2
//
//  Created by toffee on 7/9/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire

class Block: UITableViewController {
    
    var uid = ""
    var numBlock = ""

    @IBOutlet weak var btnBlock: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkBlocl()
      
    }
    
    func checkBlocl(){
        
        let urlCheckBlock = "https://nickgormanacademy.com/soccerSquat/admin/block/CheckBlock.php"
        var parameter:[String:String] = [ "uid":uid]
        
        Alamofire.request(.GET,urlCheckBlock, parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                switch response.result {
                case .Success:
                    
                    var JSON = [AnyObject]()
                    JSON = response.result.value as! [AnyObject]!
                    for value in JSON {
                        
                        self.numBlock  = (value["unumblock"] as? String)!
                        
                        
                    }
                    
                    if(self.numBlock == "3"){
                        self.btnBlock.layer.cornerRadius = 12
                        self.btnBlock.setTitle("Block 1", forState: .Normal)
                        self.btnBlock.backgroundColor = UIColor(red:0.51, green:0.91, blue:0.59, alpha:1.0)
                        self.btnBlock.tag = 1
                        self.btnBlock.addTarget(self, action: "buttonJoin:",
                            forControlEvents: UIControlEvents.TouchUpInside)
                    
                    }
                    else if(self.numBlock == "2"){
                    
                        self.btnBlock.layer.cornerRadius = 12
                        self.btnBlock.setTitle("Block 2", forState: .Normal)
                        self.btnBlock.backgroundColor = UIColor(red:0.95, green:0.67, blue:0.07, alpha:1.0)
                        self.btnBlock.tag = 1
                        self.btnBlock.addTarget(self, action: "buttonJoin:",
                            forControlEvents: UIControlEvents.TouchUpInside)
                    
                    }
                    else if(self.numBlock == "1"){
                        
                        self.btnBlock.layer.cornerRadius = 12
                        self.btnBlock.setTitle("Block 3", forState: .Normal)
                        self.btnBlock.backgroundColor = UIColor(red:0.93, green:0.37, blue:0.54, alpha:1.0)
                        self.btnBlock.tag = 1
                        self.btnBlock.addTarget(self, action: "buttonJoin:",
                            forControlEvents: UIControlEvents.TouchUpInside)
                        
                    }else{
                        self.btnBlock.layer.cornerRadius = 12
                        self.btnBlock.setTitle("Block!!", forState: .Normal)
                        self.btnBlock.backgroundColor = UIColor(red:0.90, green:0.04, blue:0.04, alpha:1.0)
                        self.btnBlock.tag = 1

                    }

                    
                     print("number1 \(self.numBlock)")
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
    
    func buttonJoin(sender: UIButton!) {  //ButtonJoin
         var parameter:[String:String] = [ "uid":uid]
        let urlBlock = "https://nickgormanacademy.com/soccerSquat/admin/block/Block.php"
        Alamofire.request(.GET,urlBlock, parameters: parameter ,encoding: .URL).validate()
            .responseJSON{(response) in
                self.checkBlocl() 
        }
                
        
    }

   }
