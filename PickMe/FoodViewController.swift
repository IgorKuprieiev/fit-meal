//
//  FoodViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/2/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {

    
    @IBOutlet weak var header: BackgroundView?
    @IBOutlet var days_buttons: [UIButton]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didSelectDay(sender: UIButton) -> Void {
        if let days = self.days_buttons {
            for day in days {
                day.isSelected = (day.tag == sender.tag)
            }
        }
    }
}
