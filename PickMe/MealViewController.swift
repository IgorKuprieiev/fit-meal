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

let WeekDays = [1 : "Sunday",
                2 : "Monday",
                3 : "Tuesday",
                4 : "Wednesday",
                5 : "Thursday",
                6 : "Friday",
                7 : "Saturday"]


class MealViewController: UIViewController {
    
    @IBOutlet weak var header: MealHeaderView?
    @IBOutlet weak var table: UITableView?
    
    var db_ref: DatabaseReference!
    var week: [MealDay]!
    var day: MealDay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meal_header = header {
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
        header?.showToday()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Header view

extension MealViewController : MealHeaderDelegate{
    
    func header(selectDay: Int) {
        
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
//        let point = schedule.points[indexPath.row]
//        cell.timelinePoint = point.readPoint
//        cell.bubbleColor = UIColor.red
//        
//        //Update colors
//        var timelineFrontColor = UIColor.clear
//        if (indexPath.row > 0) {
//            let prev_point = schedule.points[indexPath.row - 1]
//            timelineFrontColor = prev_point.readColor
//        }
//        cell.timeline.frontColor = timelineFrontColor
//        
//        var timeLineBackColor = UIColor.clear
//        if (indexPath.row < schedule.points.count - 1) {
//            timeLineBackColor = point.readColor
//        }
//        cell.timeline.backColor = timeLineBackColor
//        
//        //Put values
//        cell.titleLabel.text = point.readTime
//        cell.descriptionLabel.text = point.readMeal
//        cell.descriptionLabel.textColor = UIColor.darkGray
//        if indexPath.row + 1 < schedule.points.count {
//            let next_point = schedule.points[indexPath.row + 1]
//            point.calculateNextMeal(date: next_point.time)
//        }
//        
//        cell.lineInfoLabel.text = point.readTimeToNextMeal
//        if let thumbnail = point.icon {
//            cell.thumbnailImageView.image = UIImage(named: thumbnail)
//        }
        
        return cell
    }
}

