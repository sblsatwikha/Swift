//
//  ViewController.swift
//  21. Local Notifications
//
//  Created by Satwika on 4/24/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(schedulelocal))
    }
    
    @objc func registerLocal(){
        let centre = UNUserNotificationCenter.current()
        centre.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, Error) in
            if granted {
                print("Hurray!! Authenticated")
            } else{
                print("Oh No! ")
            }
                
        }
    }
    
    @objc func schedulelocal(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // trigger - when to show
        var dateComp = DateComponents()
        dateComp.hour = 23
        dateComp.minute = 05
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // content - what to show
        let cont = UNMutableNotificationContent()
        cont.title = "Get Ready"
        cont.body = "Meeting in an hour"
        cont.categoryIdentifier = "alarm"
        cont.sound = UNNotificationSound.default
        cont.userInfo = ["customInfo": "Be ready with your ideas"]
        
        
        // request - (trigger, content)
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: cont, trigger: trigger)
        center.add(req)
        
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell Me More", options: .foreground)
        let remindmeLater = UNNotificationAction(identifier: "remindMe", title: "Remind Me", options: .authenticationRequired)
        let cate = UNNotificationCategory(identifier: "alarm", actions: [show, remindmeLater], intentIdentifiers: [])
        center.setNotificationCategories([cate])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customeData = userInfo["customInfo"] as? String{

            switch response.actionIdentifier {
                
            case UNNotificationDefaultActionIdentifier:
                print("Default")
                
            case "show":
                
                let alert  = UIAlertController(title: response.notification.request.content.body, message: customeData, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                
            case "remindMe":
                let alert  = UIAlertController(title: response.notification.request.content.body, message: customeData, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                alert.addAction(UIAlertAction(title: "Remind Me", style: .default){ [weak self] _ in
                    self?.schedulelocal()
                })
                present(alert, animated: true)
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    

}

