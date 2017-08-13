//
//  EditLocationTableViewController.swift
//  Project2
//
//  Created by toffee on 6/24/2560 BE.
//  Copyright © 2560 Scott. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol getplace {
    func getplaceID(id: String)
    func getplaceName(name: String)
}

class EditLocationTableViewController: UITableViewController {
    
    
    
    
    var fid = ""
    var nameField = ""
    var nameImageField = ""
    
    var addFid = [String]()
    var addNameField = [String]()
    var addNameImageField = [String]()
    
    var delegate: getplace?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.doLacation()
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
        return self.addFid.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.delegate?.getplaceID(self.addFid[indexPath.row])
        self.delegate?.getplaceName(self.addNameField[indexPath.row])
        
        print(self.delegate?.getplaceID(self.addFid[indexPath.row]))
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EditLocationTableViewCell
        
        var urlImage = "https://nickgormanacademy.com/soccerSquat/owner/FieldManager/" + addNameImageField[indexPath.row]
        cell.name.text = addNameField[indexPath.row]
        getNetworkImage(urlImage) { (image) in //เรียก เมอธอทดึงรูป
            cell.imageField.image = image
            cell.imageField.contentMode = .ScaleAspectFit
            cell.imageField.layer.borderWidth = 1.0
            cell.imageField.layer.masksToBounds = false
            cell.imageField.layer.cornerRadius = cell.imageField
                .frame.size.height/2
            cell.imageField.clipsToBounds = true
        }
        return cell
        
        
    }

    
    func doLacation(){
        let urlFieldAll = "https://nickgormanacademy.com/soccerSquat/event/FieldAll.php"
        Alamofire.request(.GET,urlFieldAll  ,encoding: .URL).validate()
            .responseJSON{(response) in
                var JSON = [AnyObject]()
                JSON = response.result.value as! [AnyObject]!
                for value in JSON {
                    
                    
                    self.fid  = (value["fid"] as? String)!
                    self.nameField  = (value["fname"] as? String)!
                    self.nameImageField  = (value["fimage"] as? String)!
                    
                    self.addFid.append(self.fid)
                    self.addNameField.append(self.nameField)
                    self.addNameImageField.append(self.nameImageField)
                    
                    
                    
                    
                    
                }
             
                self.tableView.reloadData()
                
                
        }
        
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request) { //ดึงรุปจากserver
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            //print(image)
            completion(image)
        }
    }


    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
