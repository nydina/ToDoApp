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
        guard let identifier = id?.uuidString else { return } // Retrieve the identifier for the pending notification
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier]) // Remove the pending notification with the specified identifier
    }
    
    func isCompleted() -> Bool {
        if completedDate != nil { // Check if the task is marked as completed
            removePendingNotification() // Remove the pending notification associated with the task
        }
        return completedDate != nil // Return true if the task is completed, otherwise false
    }
    
    func isOverdue() -> Bool {
        if let due = dueDate { // Check if a due date is specified
            return !isCompleted() && scheduleTime && due < Date() // Return true if the task is not completed, scheduled, and the due date has passed
        }
        return false // Return false if no due date is specified
    }
    
    func overdureColor() -> Color {
        return isOverdue() ? .red : .primary // Return red color if the task is overdue, otherwise the primary color
    }
    
    func isHighPriority() -> Bool {
        return priority == "High" // Return true if the task has a high priority, otherwise false
    }
    
    func isNormalPriority() -> Bool {
        return priority == "Normal" // Return true if the task has a normal priority, otherwise false
    }
    
    func isLowPriority() -> Bool {
        return priority == "Low" // Return true if the task has a low priority, otherwise false
    }
    
}
