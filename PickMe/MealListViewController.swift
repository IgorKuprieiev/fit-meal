//
//  MealListViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/21/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit


class MealDayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var day: UILabel?
    @IBOutlet weak var today: UIImageView?
    
    override func awakeFromNib() {
        day?.transform = CGAffineTransform(rotationAngle: CGFloat.pi*1.75)
    }
}



class MealListViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView?
    var days: [(String, Date)]! = [(String, Date)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackItem()
        self.loadWeekDays()
        self.setupTabItem()
    }
    
    func setupTabItem() {
        self.tabBarItem.title = "meals"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWeekDays() {
        let calendar = Calendar.current
        var components = DateComponents()
        components.weekday = 1
        if let start = calendar.date(from: components){
            for index in 0 ... 6 {
                components.weekday = index
                if let date = calendar.date(byAdding: components, to: start, wrappingComponents: true),
                    let week_day = date.dayOfWeek(short: true) {
                    days.append((week_day, date))
                    print(week_day)
                }
            }
        }
        self.collection?.reloadData()
    }
}



extension MealListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealDayCollectionViewCell", for: indexPath) as! MealDayCollectionViewCell
        let (day, _) = self.days[indexPath.row]
        let isToday = (day != Date().dayOfWeek(short: true))
        cell.today?.isHidden = isToday
        cell.day?.text = day
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.bounds.width / 2
        return CGSize.init(width: side, height: side)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (_, date) = self.days[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "DayScheduleViewController") as? DayScheduleViewController {
            let schedule = Schedule()
            schedule.day = "Today"
            if let day = date.dayOfWeek(short: false){
                schedule.day = day
            }
            controller.schedule = schedule
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
