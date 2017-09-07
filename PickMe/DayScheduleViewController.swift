//
//  DayScheduleViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/16/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import TimelineTableViewCell



class DayScheduleViewController: UIViewController {
    
    @IBOutlet weak var timeline: UITableView?

    var schedule: Schedule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd(sender:)))
        self.navigationItem.setRightBarButton(item, animated: false)
        self.title = schedule.day
        if let line = timeline{
            let bundle = Bundle(for: TimelineTableViewCell.self)
            let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
            let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
                                                 bundle: Bundle(url: nibUrl!)!)
            line.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
            
            line.estimatedRowHeight = 300
            line.rowHeight = UITableViewAutomaticDimension
            line.reloadData()
        }
        self.setupBackItem()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapAdd(sender: UIBarButtonItem) -> Void {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MealComposerViewController") as? MealComposerViewController{
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension DayScheduleViewController: MealComposerDelegate {
    
    func didComposeMeal(point: SchedulePoint) {
        schedule.addPoint(point: point)
        timeline?.reloadData()
    }
}


extension DayScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return schedule.points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.addNotificationHandler()
        let point = schedule.points[indexPath.row]
        cell.timelinePoint = point.readPoint
        cell.bubbleColor = UIColor.red
        
        //Update colors
        var timelineFrontColor = UIColor.clear
        if (indexPath.row > 0) {
            let prev_point = schedule.points[indexPath.row - 1]
            timelineFrontColor = prev_point.readColor
        }
        cell.timeline.frontColor = timelineFrontColor
        
        var timeLineBackColor = UIColor.clear
        if (indexPath.row < schedule.points.count - 1) {
            timeLineBackColor = point.readColor
        }
        cell.timeline.backColor = timeLineBackColor
        
        //Put values
        cell.titleLabel.text = point.readTime
        cell.descriptionLabel.text = point.readMeal
        cell.descriptionLabel.textColor = UIColor.darkGray
        if indexPath.row + 1 < schedule.points.count {
            let next_point = schedule.points[indexPath.row + 1]
            point.calculateNextMeal(date: next_point.time)
        }
        
        cell.lineInfoLabel.text = point.readTimeToNextMeal
        if let thumbnail = point.icon {
            cell.thumbnailImageView.image = UIImage(named: thumbnail)
        }
        
        return cell
    }
}




extension TimelineTableViewCell{
    
    func addNotificationHandler() -> Void {
        let elements = thumbnailImageView.subviews
        if elements.count < 1 {
            thumbnailImageView.isUserInteractionEnabled = true
            let button = UIButton.init(frame: thumbnailImageView.bounds)
            
            button.showsTouchWhenHighlighted = true
            button.backgroundColor = UIColor.clear
            button.translatesAutoresizingMaskIntoConstraints = false
            thumbnailImageView.addSubview(button)
            
            var constraint: NSLayoutConstraint!
            
            constraint = NSLayoutConstraint.init(item: button,
                                                 attribute: .centerX,
                                                 relatedBy: .equal,
                                                 toItem: thumbnailImageView,
                                                 attribute: .centerX,
                                                 multiplier: 1,
                                                 constant: 0)
            thumbnailImageView.addConstraint(constraint)
            
            constraint = NSLayoutConstraint.init(item: button,
                                                 attribute: .centerY,
                                                 relatedBy: .equal,
                                                 toItem: thumbnailImageView,
                                                 attribute: .centerY,
                                                 multiplier: 1,
                                                 constant: 0)
            thumbnailImageView.addConstraint(constraint)
            
            constraint = NSLayoutConstraint.init(item: button,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: thumbnailImageView,
                                                 attribute: .height,
                                                 multiplier: 1,
                                                 constant: 0)
            thumbnailImageView.addConstraint(constraint)
            
            constraint = NSLayoutConstraint.init(item: button,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: thumbnailImageView,
                                                 attribute: .width,
                                                 multiplier: 1,
                                                 constant: 0)
            thumbnailImageView.addConstraint(constraint)
            
        }
    }
}
