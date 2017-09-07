//
//  Profile.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/10/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import Firebase

enum ProfileFields: String {
    case FirstName = "first_name"
    case LastName = "last_name"
    case Phone = "phone"
}

class Profile: NSObject {

    var firstName: String?
    var lastName: String?
    var phone: String!
    var ref: DatabaseReference!
    
    static func fetchMyProfile(phone: String, ref: DatabaseReference) -> Profile {
        let profile = Profile()
        let profile_ref = ref.child(phone)
        profile.ref = profile_ref
        profile.firstName = profile_ref.value(forKey: ProfileFields.FirstName.rawValue) as? String
        profile.lastName = profile_ref.value(forKey: ProfileFields.LastName.rawValue) as? String
        if let phone = profile_ref.value(forKey: ProfileFields.FirstName.rawValue) as? String{
            profile.phone = phone
        }else{
            profile.phone = "UNKNOWN"
        }
        return profile
    }
    
    static func createProfile(firstName: String?, lastName: String?, phone: String, ref: DatabaseReference) -> Profile {
        let profile = Profile()
        let profile_ref = ref.child(phone)
        profile.ref = profile_ref
        profile.firstName = firstName
        profile.lastName = lastName
        profile.phone = phone
        return profile
    }
    
    func save() -> Void {
        if let value = firstName{
            ref.setValue(value, forKey: ProfileFields.FirstName.rawValue)
        }
        
        if let value = lastName{
            ref.setValue(value, forKey: ProfileFields.LastName.rawValue)
        }
        
        ref.setValue(phone, forKey: ProfileFields.Phone.rawValue)
        
    }
}
