//
//  User.swift
//  Soccer Squad
//
//  Created by Jay on 5/26/2560 BE.
//  Copyright © 2560 firebaseDB. All rights reserved.
//

import UIKit

class User: NSObject {
    var ownerName: String?
    var ownerEmail: String?
    var ownerImagePicture: String?
    
    init(dictionary: [String: AnyObject]) {
        self.ownerName = dictionary["playerName"] as? String ?? ""
        self.ownerEmail = dictionary["playerEmail"] as? String ?? ""
        self.ownerImagePicture = dictionary["playerImageProfile"] as? String ?? ""
    }
    
}
