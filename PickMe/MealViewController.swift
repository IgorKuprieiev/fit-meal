//
//  MealViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/2/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import TimelineTableViewCell
import MBProgressHUD




class MealViewController: UIViewController {
    
    @IBOutlet weak var header: MealHeaderView?
    @IBOutlet weak var table: UITableView?
    
    var db_ref: DatabaseReference!
    var week: [MealDay]!
    var day: MealDay?
    
    private func setup_database_connection() -> Void {
        //Here actually we aply some data to the ref member - later on it should be done from the outside 
        
        let meal = remotedatabase.ref.child("Meal")
        db_ref = meal.child("J4LDgqpCMcSGuaQFmofHM9gz48Z2")
        
        week = [MealDay]()
        
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.numberOfLines = 0
        hud.label.lineBreakMode = NSLineBreakMode.byWordWrapping
        hud.label.text = "fetching meal plan"
        
        db_ref.observeSingleEvent(of: DataEventType.value, with: { (snap) in
            self.week.removeAll()
            if let days = snap.value as? [Any] {
                for key in days {
                    print(key)
                    if let day_info = key as? [String : Any] {
                        let meal_day = MealDay.init(node: day_info)
                        self.week.append(meal_day)
                        self.header?.showToday()
                    }
                }
                hud.hide(animated: true, afterDelay: 1.5)
            }
            self.start_observe(ref: self.db_ref)
        })
        
        
//        //If smb would like to add some day
//        db_ref.observe(DataEventType.childAdded, with: { (snap) in
//            if let day_info = snap.value as? [String : Any] {
//                let updated_day = MealDay.init(node: day_info)
//                self.update(meal_day: updated_day, to_remove: false)
//                self.popup_info(message: String.init(format: "meal plan for %@\rhas been added", updated_day.day_title))
//            }
//        })
//        
//        //For sure for removeing as well
//        db_ref.observe(DataEventType.childRemoved, with: { (snap) in
//            if let day_info = snap.value as? [String : Any] {
//                let updated_day = MealDay.init(node: day_info)
//                self.update(meal_day: updated_day, to_remove: true)
//                self.popup_info(message: String.init(format: "meal plan for %@\rhas been removed", updated_day.day_title))
//            }
//        })
    }
    
    
    private func popup_info(message: String) -> Void {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.numberOfLines = 0
        hud.label.lineBreakMode = NSLineBreakMode.byWordWrapping
        hud.label.text = message
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    
    private func observe_meal_changes(meal_plan: MealDay, parent_ref: DatabaseReference) -> Void {
        let meal_ref = parent_ref.child("\(meal_plan.day)" + "/meals")
        meal_ref.observe(DataEventType.value, with: { (snap) in
            meal_plan.update(meals: snap.value)
        })
        week.append(meal_plan)
    }
    
    
    
    
    private func start_observe(ref: DatabaseReference) -> Void {
        ref.observe(DataEventType.childChanged, with: { (snap) in
            if let day_info = snap.value as? [String : Any] {
                let updated_day = MealDay.init(node: day_info)
                self.update(meal_day: updated_day, to_remove: false)
                self.popup_info(message: String.init(format: "meal plan for %@\rhas been updated", updated_day.day_title))
            }
        })
    }
    
    
    private func update(meal_day: MealDay, to_remove: Bool) -> Void {
        var exist = false
        var remove_index = 0
        for meal in week {
            if meal.day == meal_day.day{
                exist = true
                meal.update(meal_day: meal_day)
                if meal == day {
                    if to_remove {
                        day = nil
                    }
                    table?.reloadData()
                }
            }
            remove_index = remove_index + 1
        }
        
        if to_remove,
            remove_index < week.count{
            week.remove(at: remove_index)
        }
        
        if !exist {
            week.append(meal_day)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setup_database_connection()
        
        if let meal_header = header {
            meal_header.delegate = self
            meal_header.addShadow()
            meal_header.addGradient(top: UIColor(red: 213/255, green: 173/255, blue: 230/255, alpha: 1),
                               bot: UIColor(red: 162/255, green: 147/255, blue: 230/255, alpha: 1))
        }
        
        if let line = table{
            let bundle = Bundle(for: TimelineTableViewCell.self)
            let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
            let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                                 bundle: Bundle(url: nibUrl!)!)
            line.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
            
            line.estimatedRowHeight = 300
            line.rowHeight = UITableViewAutomaticDimension
            line.reloadData()
            
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.tintColor = UIColor.black
            refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
            line.addSubview(refreshControl)
        }
    }
    
    func refresh(sender: UIRefreshControl) -> Void {
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.init(uptimeNanoseconds: 1000)) {
            sender.endRefreshing()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigation = self.navigationController {
            navigation .setNavigationBarHidden(true, animated: true)
        }
        
        header?.showToday()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Header view

extension MealViewController : MealHeaderDelegate{
    
    func header(notify: Bool) {
        if let meal_day = self.day{
            if notify {
                notifications.startObserve(day: meal_day)
            }else{
                notifications.stopObserve(day: meal_day)
            }
            
            let ref = db_ref.child("\( meal_day.day)/notify")
            ref.setValue(notify, withCompletionBlock: { (err, snap_ref) in
                if err != nil {
                    
                }
            })
        }
    }

    func header(selectDay: Int) -> Bool {
        day = nil
        for item in week {
            if item.day == selectDay {
                day = item
                table?.reloadData()
                return item.notify
            }
        }
        return false
    }

    
    func header(openSettings: UIButton?) {
        
    }
    
}


//MARK: - Table view 

extension MealViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //#warning Incomplete implementation, return the number of rows
        var count = 0
        if let selected = self.day {
            count = selected.meals.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        if let items = self.day?.meals {
            let meal = items[indexPath.row]
            cell.timelinePoint = TimelinePoint()
            cell.titleLabel.text = meal.time
            cell.descriptionLabel.text = meal.content
            
            var timelineFrontColor = UIColor.clear
            if indexPath.row > 0 {
                timelineFrontColor = UIColor.darkGray
            }
            cell.timeline.frontColor = timelineFrontColor
            
            
            var timeLineBackColor = UIColor.clear
            if (indexPath.row < items.count - 1) {
                timeLineBackColor = UIColor.darkGray
            }
            cell.timeline.backColor = timeLineBackColor
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let items = self.day?.meals,
            let navigation = self.navigationController {
            let meal = items[indexPath.row]
            if let details = storyboard?.instantiateViewController(withIdentifier: "MealDetailsViewController") as? MealDetailsViewController {
                navigation.pushViewController(details, animated: true)
            }
        }
    }
}

