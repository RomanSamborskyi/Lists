//
//  NotificationManager.swift
//  Lists
//
//  Created by Roman Samborskyi on 09.08.2023.
//

import Foundation
import UserNotifications


class NotificationManager {
    
    static var instance = NotificationManager()
    
    func request() {
        let options: UNAuthorizationOptions = [.badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR OF AUTHORIZATION: \(error)")
            }
        }
    }
    
    func makeNotitfication(badge: NSNumber) {
        
        let content = UNMutableNotificationContent()
        content.badge = badge
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        let reequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triger)
        UNUserNotificationCenter.current().add(reequest)
    }
}
