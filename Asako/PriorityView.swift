//
//  PriorityView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 06/01/2023.
//

import SwiftUI

struct PriorityView: View {
    @ObservedObject var passedTaskItem: TaskItem
    
    var body: some View {
        if passedTaskItem.isHighPriority() {
            Image(systemName: "circle.fill")
                .foregroundColor(.red)
        } else if passedTaskItem.isNormalPriority() {
            Image(systemName: "circle.fill")
                .foregroundColor(.orange)
        } else {
            Image(systemName: "circle.fill")
                .foregroundColor(.green)
        }
        
    }
    
}

