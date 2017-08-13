//
//  Extension.swift
//  Soccer Squad
//
//  Created by Jay on 6/9/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit

let imageCache = NSCache()


extension UIImageView {
    
    func loadImageUsinCacheWithUrlString(urlString: String) {
        
//        self.image = nil
        
        //Check cache for image first
        if let cacheImage = imageCache.objectForKey(urlString) as? UIImage {
            self.image = cacheImage
            return
        }
        
        
        //otherwise fire off a new download
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadImage = UIImage(data: data!) {
                    
                    imageCache.setObject(downloadImage, forKey: urlString)
                    
                    self.image = downloadImage
                }
                

                
                //                    cell.imageView?.image = UIImage(data: data!)
                
            })
            
            
        }).resume()
    }
}
