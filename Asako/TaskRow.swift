//
//  TaskRow.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//

import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var dateHolder: TaskViewModel
    @ObservedObject var passedTaskItem: TaskItem
    
    var body: some View {
        HStack {
            CheckBoxView(passedTaskItem: passedTaskItem)
            
            passedTaskItem.isCompleted() ? Text(passedTaskItem.name ?? "").strikethrough() : Text(passedTaskItem.name ?? "")
            
            Spacer()
            if !passedTaskItem.isCompleted() && passedTaskItem.scheduleTime {

                VStack {
                    Image(systemName: "bell.fill")
                                            Text(passedTaskItem.dueDate?.formatted(date: .numeric, time: .omitted) ?? "")
                        
                        
                        .padding(.horizontal)
                }
                .font(.footnote)
                .foregroundColor(passedTaskItem.overdureColor())
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Spacer()
            PriorityView(passedTaskItem: passedTaskItem)
                
            
        }
        
    }
}


