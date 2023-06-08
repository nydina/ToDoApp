//
//  TaskItemExtension .swift
//  Asako
//
//  Created by Dina Andrianarijaona on 05/01/2023.
//

import Foundation
import SwiftUI
import UserNotifications

extension TaskItem {

    func removePendingNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        guard let identifier = id?.uuidString else { return }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func isCompleted() -> Bool {
            if completedDate != nil {
                removePendingNotification()
            }
            return completedDate != nil
        }
    
    func isOverdue() -> Bool {
        if let due = dueDate {
            return !isCompleted() && scheduleTime && due < Date()
        }
        return false
    }
    
    func overdureColor() -> Color {
        return isOverdue() ? .red : .primary
    }
    
    func isHighPriority() -> Bool {
        return priority == "High"
    }
    
    func isNormalPriority() -> Bool {
        return priority == "Normal"
    }
    
    func isLowPriority() -> Bool {
        return priority == "Low"
    }
    
}

