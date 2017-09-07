//
//  Database.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/5/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase


open class RemoteDatabase {
    
    open static let shared = RemoteDatabase()
    
    var ref = Database.database().reference()
    
    
}
