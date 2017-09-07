//
//  Schedule.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/16/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import TimelineTableViewCell

let formatter = DateFormatter()


class Schedule: NSObject {
    var week_day: Int!
    var day: String!
    var points = [SchedulePoint]()
    
    func addPoint(point: SchedulePoint) -> Void {
        points.append(point)
        organize()
    }
    
    func removePoint(point: SchedulePoint) -> Void {
        var index: Int?
        var counter = 0
        for schedule_point in points{
            if point == schedule_point {
                index = counter
            }
            counter = counter + 1
        }
        
        if let at = index{
            points.remove(at: at)
        }
    }
    
    func organize() -> Void {
        points.sort { (point1, point2) -> Bool in
            return (point1.time.timeIntervalSince1970 < point2.time.timeIntervalSince1970)
        }
    }
}


class SchedulePoint: NSObject {
    var order: Int!
    let point = TimelinePoint()
    var lineColor: UIColor!
    var time: Date!
    var meal: String!
    var nextMealIn: String!
    var icon: String?
    
    
    convenience init(order: Int, color: UIColor, time: Date, meal: String) {
        self.init()
        self.order = order
        self.lineColor = color
        self.time = time
        self.meal = meal
        self.icon = "bell_off"
        self.nextMealIn = ""
    }
    
    public func calculateNextMeal(date: Date) -> Void {
        let interval = NSInteger(date.timeIntervalSince(time))
        let hours = (interval / 3600)
        let minutes = (interval / 60) % 60
        nextMealIn = String.init(format: "%0.2d h\r %0.2d min", hours, minutes)
    }
    
    var readPoint: TimelinePoint {
        return TimelinePoint()
    }
    
    var readColor: UIColor {
        return lineColor
    }
    
    var readTime: String {
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: time)
    }
    
    var readMeal: String {
        return meal
    }
    
    var readTimeToNextMeal: String {
        
        return nextMealIn
    }
    
    var readIcon: String {
        return "bell_off"
    }
}
