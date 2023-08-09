//
//  Extensions.swift
//  Lists
//
//  Created by Roman Samborskyi on 08.08.2023.
//

import Foundation
import UIKit


//Enum in item list view for switch beatween actions 
enum BottomActions {
    case addItem, editItem, addButton
}

class HapticEngine {
 
    static var instance = HapticEngine()
    
    func getImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
     let generetor = UIImpactFeedbackGenerator(style: style)
        generetor.impactOccurred()
    }
    
    func getNotification(style: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(style)
    }
}

