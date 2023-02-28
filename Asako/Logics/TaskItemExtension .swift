//
//  TaskItemExtension .swift
//  Asako
//
//  Created by Dina Andrianarijaona on 05/01/2023.
//

import Foundation
import SwiftUI

extension TaskItem {
    
    func isCompleted() -> Bool {
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
