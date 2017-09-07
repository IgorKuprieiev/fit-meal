//
//  MealComposerViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/16/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import DatePickerDialog


protocol MealComposerDelegate {
    func didComposeMeal(point: SchedulePoint) -> Void;
}


class MealComposerViewController: UIViewController {

    @IBOutlet weak var time: UILabel?
    @IBOutlet weak var meal: UILabel?
    @IBOutlet weak var picker: UIDatePicker?
    @IBOutlet weak var pickerHeight: NSLayoutConstraint?
    var point = SchedulePoint.init(order: 0, color: UIColor.gray, time: Date(), meal: "")
    
    
    public var delegate: MealComposerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.save , target: self, action: #selector(didTapSave(sender:)))
        self.navigationItem.setRightBarButton(item, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didTapSave(sender: UIBarButtonItem) -> Void {
        if let responder = delegate {
            responder.didComposeMeal(point: point)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func didTapDate(sender: UIButton) -> Void {
        let dialog = DatePickerDialog()
        dialog.show("Chose your meal time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if let time = date{
                formatter.dateFormat = "hh:mm"
                self.point.time = time
                self.time?.text = formatter.string(from: time)
            }
        }
        dialog.datePicker.minuteInterval = 5
    }
    
    @IBAction func didTapMenu(sender: UIButton) -> Void {
        let alert = UIAlertController.init(title: "Add meal", message: "put your meal here...", preferredStyle: .alert)
        alert.addTextField { (field) in
            field.placeholder = "about your meal..."
        }
        
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
            if let fields = alert.textFields,
                let field = fields.first,
                let input = field.text {
                var list = "- " + input
                if let previous_list = self.meal?.text,
                    !previous_list.isEmpty {
                    list = String.init(format: "%@\r%@", previous_list, list)
                }
                self.point.meal = list
                self.meal?.text = list
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
