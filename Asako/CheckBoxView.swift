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
    var viewContext: NSManagedObjectContext
    
    var body: some View {
        Image(systemName: taskItem.isCompleted() ? "checkmark.circle.fill" : "circle")
            .font(.largeTitle)
            .foregroundColor(taskItem.isCompleted() ? .accentColor : .secondary)
            .onTapGesture {
                withAnimation {
                    if !taskItem.isCompleted() {
                        taskItem.completedDate = Date()
                        taskViewModel.saveContext(viewContext)
                    }
                }
            }
    }
}

