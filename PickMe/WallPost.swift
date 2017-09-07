//
//  WallPost.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/1/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import Firebase

enum PostFields: String {
    case owner = "owner"
    case media = "file"
    case content = "content"
    case date = "date"
}


class WallPost: NSObject {

    var owner: String!
    var date: Date!
    var content: String?
    var media: String?
    var file: UIImage?
    
    public var time_stamp: String {
    
        let date_formatter = formatter
        date_formatter.dateFormat = "hh:mm"
        
        guard let value = date_formatter.string(from: date) as String? else {
            return ""
        }
        return value
    }
    
    static func create(owner: String, text: String?, media: UIImage?) -> WallPost {
        let post = WallPost()
        post.owner = owner
        post.content = text
        post.file = media
        post.date = Date()
        return post
    }
    
    public func submit() -> Void{
        
    }
}
