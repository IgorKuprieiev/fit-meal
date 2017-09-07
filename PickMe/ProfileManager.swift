//
//  ProfileManager.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/5/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase


open class ProfileManager {
    
    open static let shared = ProfileManager()

    public var user: User!
    
    public func verify(usr: User) -> Bool {
        self.user = usr
        return self.user.isEmailVerified
    }
}

