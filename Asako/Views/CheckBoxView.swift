//
//  CheckBoxView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 05/01/2023.
//

import SwiftUI
import CoreData

struct CheckBoxView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    var taskItem: TaskItem
    
    var body: some View {
        Image(systemName: taskViewModel.selectedTaskItem?.isCompleted() ?? taskItem.isCompleted() ? "checkmark.circle.fill" : "circle")
            .font(.largeTitle)
            .foregroundColor(taskViewModel.selectedTaskItem?.isCompleted() ?? taskItem.isCompleted()  ? .accentColor : .secondary)
            .onTapGesture {
                withAnimation {
                    if !(taskViewModel.selectedTaskItem?.isCompleted() ?? false)  {
                        taskItem.completedDate = Date()
                        taskViewModel.saveContext()
                    }
                }
            }
    }
}

