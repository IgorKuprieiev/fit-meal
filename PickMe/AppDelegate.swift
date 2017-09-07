//
//  AppDelegate.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/10/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    override init() {
        FirebaseApp.configure()
        MagicalRecord.setupCoreDataStack()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let appearence = UINavigationBar.appearance()
//        let img = UIImage.init(named: "nav_bar")
//        appearence.setBackgroundImage(img, for: UIBarMetrics.default)
        appearence.tintColor = UIColor.white
        appearence.barTintColor = UIColor.clear
        var params = [NSForegroundColorAttributeName : UIColor.white] as [String : Any]
        if let font = UIFont(name: "Chalkduster", size: 18) as UIFont? {
            params[NSFontAttributeName] = font
        }
        appearence.titleTextAttributes = params
        
        let tab_appearence = UITabBar.appearance()
        tab_appearence.tintColor = UIColor(red: 0/255, green: 171/255, blue: 205/255, alpha: 1)
        
        let options: UNAuthorizationOptions = [.alert, .sound];
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            center.removeAllPendingNotificationRequests()
        case UNNotificationDefaultActionIdentifier:
            center.removeAllPendingNotificationRequests()
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
            center.removeAllPendingNotificationRequests()
            center.removeAllDeliveredNotifications()
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, shouldSchedule response: UNNotificationResponse) -> Void {
        
        let request = response.notification.request

        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }

    }
}


