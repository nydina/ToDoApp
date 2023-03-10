//
//  TaskEditView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//

import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var selectedTaskItem: TaskItem?
    @State var name: String
    @State var desc: String
    @State var priority =  "High"
    @State var dueDate: Date
    @State var scheduleTime: Bool
    
    init(passedTaskItem: TaskItem?, initialDate: Date) {
        if let taskItem = passedTaskItem {
            
            _selectedTaskItem = State(initialValue: taskItem)
            _name = State(initialValue: taskItem.name ?? "")
            _desc = State(initialValue: taskItem.desc ?? "")
            _priority = State(initialValue: taskItem.priority ?? "Normal")
            _dueDate = State(initialValue: taskItem.dueDate ?? initialDate)
            _scheduleTime = State(initialValue: taskItem.scheduleTime)
        }
        else {
            
            _name = State(initialValue: "")
            _desc = State(initialValue: "")
            _priority = State(initialValue: "High")
            _dueDate = State(initialValue: initialDate)
            _scheduleTime = State(initialValue: false)
        }
    }
    
    var body: some View {            Form {
        Section("Task") {
            TextField("Task name", text: $name)
            TextField("Task description", text: $desc)
        }
        Section("Priority") {
            Picker("", selection: $priority) {
                ForEach(["High", "Normal", "Low"], id: \.self) { priority in
                    Text(priority)
                }
            }              .frame(maxWidth: .infinity)
                .pickerStyle(.segmented)
        }
        Section("Due Date") {
            Toggle("Schedule Time", isOn: $scheduleTime)
            DatePicker("Due Date", selection: $dueDate,in: Date()..., displayedComponents: displayComps())
        }
        
        if selectedTaskItem?.isCompleted() ?? false {
            Section("Completed", content: {
                Text(selectedTaskItem?.completedDate?.formatted(date: .abbreviated, time: .shortened) ?? "")
                    .foregroundColor(.green)
            })
        }
        
        Button(selectedTaskItem == nil ? "Save" : "Uptade") {
            taskViewModel.saveAction(id: UUID(), created: Date(), name: name, desc: desc, priority: priority, dueDate: dueDate, scheduleTime: scheduleTime, completion: {task in
                if scheduleTime {
                    taskViewModel.scheduleNotification(task: task)} })
            
            dismiss()
            
        }
        .disabled(name == "")
        .frame(maxWidth: .infinity, alignment: .center)
    }
    .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            ShareLink(item: selectedTaskItem?.name ?? "", subject: Text("New task assigned to you"), message: Text("Task: \(selectedTaskItem?.name ?? ""), Task due date: \(selectedTaskItem?.dueDate?.formatted(date: .long, time: .shortened) ?? "")")) {
                Image(systemName: "square.and.arrow.up")            }
            .disabled(name == "" || scheduleTime == false)
            .accessibilityLabel("shareTask")
            
        }
        
    }
        
    .tint(.accentColor)
        
    }
    
    func displayComps() -> DatePickerComponents {
        return scheduleTime ? [.hourAndMinute,  .date] : [.date]
    }
    
    
}

struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView(passedTaskItem: TaskItem(), initialDate: Date())
    }
}
