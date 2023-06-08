//
//  TaskRow.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//
import SwiftUI
import CoreData

struct TaskRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var taskViewModel: TaskViewModel
    let taskItem: TaskItem
    
    var body: some View {
        HStack {
            CheckBoxView(taskItem: taskItem, viewContext: viewContext)
            
            if taskItem.isCompleted() {
                Text(taskItem.name!)
                    .strikethrough()
            } else {
                Text(taskItem.name ?? "")
            }
            
            Spacer()
            
            if !taskItem.isCompleted() && taskItem.scheduleTime {
                VStack {
                    Image(systemName: "bell.fill")
                    if let dueDate = taskItem.dueDate {
                        Text(dueDate.formatted(date: .numeric, time: .omitted))
                            .padding(.horizontal)
                    }
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
