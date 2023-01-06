//
//  TaskFilter.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 06/01/2023.
//

import Foundation
import SwiftUI

enum TaskFilter: String {
    
    static var allFilters: [TaskFilter] {
        return [.NonCompleted, .Completed, .OverDue, .All]
    }
    
    case All = "All"
    case NonCompleted = "To Do"
    case Completed = "Completed"
    case OverDue = "Overdue"
    
}
