//
//  AuthViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/2/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD
import UserNotifications

class AuthViewController: UIViewController {
    
    @IBOutlet weak var input: UIView?
    @IBOutlet weak var container: UIScrollView?
    @IBOutlet weak var background: BackgroundView?
    @IBOutlet weak var email: UITextField?
    @IBOutlet weak var pass: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        background?.colors = [ /*UIColor(red: 63/255, green: 144/255, blue: 255/255, alpha: 0.5),
                               UIColor(red: 137/255, green: 255/255, blue: 144/255, alpha: 0.5)*/ UIColor(red: 213/255, green: 173/255, blue: 230/255, alpha: 1),
        UIColor(red: 162/255, green: 147/255, blue: 230/255, alpha: 1)]
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func verify(sender: UIButton) -> Void {
        var email_value: String!
        var pass_value: String!
        if let email_field = email,
            let text = email_field.text,
            !text.isEmpty{
            email_value = text
        }else{
            showErrorMessage(message: "Email field couldn't be empty")
            return
        }
        
        if let pass_field = pass,
            let text = pass_field.text,
            !text.isEmpty{
            pass_value = text
        }else{
            showErrorMessage(message: "Password field couldn't be empty")
            return
        }

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.animationType = MBProgressHUDAnimation.zoom
        hud.label.text = "verifying..."
        let credential = EmailAuthProvider.credential(withEmail: email_value, password: pass_value)
        Auth.auth().signIn(with: credential) { (usr, err) in
            if let error = err {
                self.showErrorMessage(message: error.localizedDescription)
            }else{
                if let user = usr{
                    profilemanager.verify(usr: user)
                    self.loadUser(user: user)
                }
            }
            hud.removeFromSuperview()
        }
    }
    
    
    @IBAction func create(sender: UIButton) -> Void {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "New minute!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!",
                                                                arguments: nil)
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "ReminderCategory"
        
        // Configure the trigger for a 7am wakeup.
        var dateInfo = DateComponents()
        dateInfo.second = 59
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        // Create the request object.
        let request = UNNotificationRequest(identifier: "ReminderCategory", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction",
                                                title: "Delete", options: [.destructive])
        
       
        
        let category = UNNotificationCategory(identifier: "ReminderCategory",
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    
    private func showErrorMessage(message: String) -> Void {
        let alert = UIAlertController.init(title: "Auth error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func loadUser(user: User) -> Void {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "RootViewController") as? RootViewController{
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func keyboardWillShow(sender: Notification) -> Void {
        if let info = sender.userInfo,
            let frame_value = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue{
            let kb_size = frame_value.cgRectValue
            container?.contentInset = UIEdgeInsetsMake(0, 0, kb_size.height, 0)
            if let fake_view = input {
                container?.scrollRectToVisible(fake_view.frame, animated: true)
            }
        }
    }
    
    
    func keyboardWillHide(sender: Notification) -> Void {
        container?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}


extension AuthViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}




