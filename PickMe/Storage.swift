//
//  Storage.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/17/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase



open class RemoteStorage {
    
    open static let shared = RemoteStorage()
    
    var ref = Storage.storage().reference()
 
    static func uploadImage(img: UIImage, name: String, callback: @escaping (StorageMetadata?, Error?) -> Void) -> StorageUploadTask? {
        guard let img_data = UIImageJPEGRepresentation(img, 0.7) else {
            return nil
        }
        
        //Create ref to img on server side
        let img_ref = shared.ref.child(name)
        
        //Add some info to task
        let upload_info = StorageMetadata()
        upload_info.contentType = "image/jpeg"
        
        //Create upload task
        let upload_task = img_ref.putData(img_data, metadata: upload_info) { (data_info, err) in
            callback(data_info, err)
        }
        return upload_task
    }
}


