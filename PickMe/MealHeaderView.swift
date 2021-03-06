//
//  MealHeaderView.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/2/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit

protocol MealHeaderDelegate {
    func header(selectDay: Int) -> Bool
    func header(openSettings: UIButton?) -> Void
    func header(notify: Bool) -> Void
}


class MealHeaderView: UIView {
    
    var delegate: MealHeaderDelegate?
    
    var notifications_on: Bool = false
    
    //Title of meal day
    @IBOutlet weak var title: UILabel?
    
    //Main bg with shadows and so on
    @IBOutlet weak var background: BackgroundView?
    
    //Just for fun - kinda bar or smth loke that
    @IBOutlet weak var rounded_background: UIView?
    
    //Days to interact with
    @IBOutlet var days_buttons: [UIButton]?
    
    //Top right item
    @IBOutlet var settings_button: UIButton?
    
    //Top left item
    @IBOutlet var notify_button: UIButton?
    
    
    override var bounds: CGRect {
        didSet {
            if let rounded = self.rounded_background {
                rounded.layer.cornerRadius = rounded.bounds.height/2
            }
            
            if let days = self.days_buttons {
                for day in days {
                    day.layer.cornerRadius = day.bounds.height/4
                }
            }
        }
    }
    
    
    func addShadow() {
        background?.isShadowed = true
    }
    
    
    func addGradient(top: UIColor, bot: UIColor) -> Void {
        background?.colors = [top , bot]
    }
    
    
    func showToday() {
        if let btn = selectDay(week_day: Date().getDayOfWeek()) {
            btn.backgroundColor = UIColor.orange
        }
    }
    
    private func updateNotifications() -> Void {
        var img = "notify_off"
        var color = UIColor.white
        if notifications_on {
            img = "notify_on"
            color = UIColor.orange
        }
        self.notify_button?.setImage(UIImage.init(named: img), for: UIControlState.normal)
        self.notify_button?.tintColor = color
    }
    
    
    private func isToday(week_day: Int) -> Bool {
        let today_day = Date().getDayOfWeek()
        return (today_day == week_day)
    }
    
    
    private func selectDay(week_day: Int) -> UIButton? {
        notifications_on = false
        var button: UIButton?
        var day_value = "Today"
        if let days = self.days_buttons {
            for day in days {
                let result = (day.tag == week_day)
                day.isSelected = result
                if result {
                    if let responder = self.delegate {
                        notifications_on = responder.header(selectDay: week_day)
                    }
                    button = day
                    if !isToday(week_day: week_day){
                        if let value = WeekDays[week_day] as String? {
                            day_value = value
                        }
                    }
                }
            }
        }
        self.updateNotifications()
        self.title?.text = String.init(format: "%@'s meal", day_value)
        return button
    }
    
    
    @IBAction func didSelectDay(sender: UIButton) -> Void {
        let _ = selectDay(week_day: sender.tag)
    }
    
    
    @IBAction func didSelectSettings(sender: UIButton) -> Void {
        if let responder = self.delegate {
            responder.header(openSettings: sender)
        }
    }
    
    @IBAction func didSelectNotify(sender: UIButton) -> Void {
        notifications_on = !notifications_on
        updateNotifications()
        if let responder = self.delegate {
            responder.header(notify: notifications_on)
        }
    }
}
