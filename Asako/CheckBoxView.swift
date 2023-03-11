//
//  CheckBoxView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 05/01/2023.
//

import SwiftUI

struct CheckBoxView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: TaskViewModel
    var taskItem: TaskItem
    
    var body: some View {
        Image(systemName: taskItem.isCompleted() ? "checkmark.circle.fill" : "circle")
            .font(.largeTitle)
            .foregroundColor(taskItem.isCompleted() ? .accentColor : .secondary)
            .onTapGesture {
                withAnimation {
                    if !taskItem.isCompleted() {
                        taskItem.completedDate = Date()
                        dateHolder.saveContext(viewContext)
                    }
                }
            }
    }
}

