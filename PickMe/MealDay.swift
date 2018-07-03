//
//  MealDay.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/2/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MealDay: NSObject {

    var db_ref: DatabaseReference? {
        didSet {
            if let ref = db_ref {
                ref.observe(DataEventType.value, with: { (snap) in
                    if let meals_info = snap.value as? [Any] {
                        
                    }
                })
            }
        }
    }
    
    private var node: [String : Any]!
    
    public var last_update: String {
        var item = String.init(format: "%lu", Date().timeIntervalSince1970)
        if let value = node["last_update"] as? String {
            item = value
        }
        return item

    }
    
    public var notify: Bool {
        var item = false
        if let value = node["notify"] as? Bool{
            item = value
        }
        return item
    }
    
    public var day: Int {
        var item = 1
        if let value = node["day"] as? Int{
            item = value
        }
        return item
    }
    
    
    public var day_title: String {
        var item = "Today"
        for (index, title) in WeekDays {
            if index == day {
                item = title
            }
        }
        return item
    }
    
    
    public var meals: [Meal] {
        var items = [Meal] ()
        if let value = node["meals"] as? [Any]{
            for meal in value {
                print("Meal parsing:", meal)
                if let meal_info = meal as? [String : Any] {
                    items.append(Meal.init(node: meal_info))
                }
            }
        }
        return items
    }
    
    public init(node: [String : Any]) {
        super.init()
        self.node = node
    }
    
    
    public func update(meal_day: MealDay) -> Void {
        self.node = meal_day.node
    }
    
    
    public func update(meals: Any?) -> Void {
        self.node["meals"] = meals
    }
    
}


class Meal: NSObject {
    
    private var node: [String : Any]!
    
    public var time: String {
        var item = "Now"
        if let value = node["time"] as? String {
            item = value
        }
        return item
    }
    
    public var timestamp: Date{
        var item = Date()
        if let value = node["time"] as? String {
            formatter.dateFormat = "hh:mm"
            if let new_item = formatter.date(from: value){
                item = new_item
            }
        }
        return item
    }
    
    
    public var content: String {
        var item = "empty content"
        if let value = node["content"] as? String {
            item = value
        }
        return item
    }
    
    public init(node: [String : Any]) {
        super.init()
        self.node = node
    }
    
}
