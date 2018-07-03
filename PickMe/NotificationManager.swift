//
//  NotificationManager.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/8/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import Foundation
import UserNotifications

let WeekDays = [1 : "Sunday",
                2 : "Monday",
                3 : "Tuesday",
                4 : "Wednesday",
                5 : "Thursday",
                6 : "Friday",
                7 : "Saturday"]


public let notifications = Notifications.shared

open class Notifications {
    
    open static let shared = Notifications()
    
    var isConfigured: Bool = false
    
    private func setup_categories() -> Void {
        var categories = Set<UNNotificationCategory>.init()
        for (_, day_title)  in WeekDays {
            let stop = UNNotificationAction(identifier: "Stop",
                                            title: "Stop", options: [.destructive])
            
            let category = UNNotificationCategory(identifier: day_title,
                                                  actions: [stop],
                                                  intentIdentifiers: [],
                                                  options: [])
            categories.insert(category)
        }
        UNUserNotificationCenter.current().setNotificationCategories(categories)
        isConfigured = true
    }
    
    
    private func category_by_day(day: Int) -> String {
        for (day_number, day_title)  in WeekDays {
            if day_number == day {
                return day_title
            }
        }
        let (_, category) = WeekDays.first!
        return category
    }
    
    
    func startObserve(day: MealDay) -> Void {
        if !isConfigured{
            setup_categories()
        }
        
        let center = UNUserNotificationCenter.current()
        for meal in day.meals {
            let day_number = day.day
            let request = create_notification(day: day_number, meal: meal, category: category_by_day(day: day_number))
            center.add(request, withCompletionHandler: { (err) in
                if err != nil {
                    print(err?.localizedDescription ?? "Couldn't add notification to the schedule list")
                }
            })
        }
    }
    
    
    func stopObserve(day: MealDay) -> Void {
        if !isConfigured{
            setup_categories()
        }
        
        let category = category_by_day(day: day.day)
        stopObserve(category: category)
    }
    
    func stopObserve(category: String) -> Void {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            var identifiers = [String]()
            for request in requests {
                let category_id = request.content.categoryIdentifier
                if category_id == category {
                    identifiers.append(request.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    private func create_notification(day: Int, meal: Meal, category: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Meal time!", arguments: nil)
        let message = String.init(format: "Hey, it's %@! Time to take your meal:\r%@", meal.time, meal.content)
        content.body = NSString.localizedUserNotificationString(forKey: message,
                                                                arguments: nil)
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = category
        
        var date_components = DateComponents()
        date_components.weekday = day
        date_components.hour = meal.timestamp.hour_components()
        date_components.minute = meal.timestamp.minute_components()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date_components, repeats: true)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: category, content: content, trigger: trigger)
        
        return request
    }
    
}
