//
//  PriorityView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 06/01/2023.
//

import SwiftUI

struct PriorityView: View {
    var taskItem: TaskItem
    
    var body: some View {
        if taskItem.isHighPriority() {
            Image(systemName: "circle.fill")
                .foregroundColor(.red)
        } else if taskItem.isNormalPriority() {
            Image(systemName: "circle.fill")
                .foregroundColor(.orange)
        } else {
            Image(systemName: "circle.fill")
                .foregroundColor(.green)
        }
        
    }
    
}

