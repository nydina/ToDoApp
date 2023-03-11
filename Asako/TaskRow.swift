//
//  TaskRow.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//

import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var dateHolder: TaskViewModel
    var taskItem: TaskItem
    
    var body: some View {
        HStack {
            CheckBoxView(taskItem: taskItem)
            
            taskItem.isCompleted() ? Text(taskItem.name ?? "").strikethrough() : Text(taskItem.name ?? "")
            
            Spacer()
            if !taskItem.isCompleted() && taskItem.scheduleTime {

                VStack {
                    Image(systemName: "bell.fill")
                                            Text(taskItem.dueDate?.formatted(date: .numeric, time: .omitted) ?? "")
                        
                        
                        .padding(.horizontal)
                }
                .font(.footnote)
                .foregroundColor(taskItem.overdureColor())
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Spacer()
            PriorityView(taskItem: taskItem)
                
            
        }
        
    }
}


