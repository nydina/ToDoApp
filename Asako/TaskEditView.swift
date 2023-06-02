//
//  TaskEditView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//
import SwiftUI

struct TaskEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    @State var taskItem: TaskItem?
    @State var name: String
    @State var desc: String
    @State var priority =  "High"
    @State var dueDate: Date
    @State var scheduleTime: Bool
    
    init(passedTaskItem: TaskItem?, initialDate: Date) {
        _taskItem = State(initialValue: passedTaskItem)
        _name = State(initialValue: passedTaskItem?.name ?? "")
        _desc = State(initialValue: passedTaskItem?.desc ?? "")
        _priority = State(initialValue: passedTaskItem?.priority ?? "Normal")
        _dueDate = State(initialValue: passedTaskItem?.dueDate ?? initialDate)
        _scheduleTime = State(initialValue: passedTaskItem?.scheduleTime ?? false)
    }
    
    var body: some View {
        Form {
            Section("Task") {
                TextField("Task name", text: $name)
                TextField("Task description", text: $desc)
            }
            Section("Priority") {
                Picker("", selection: $priority) {
                    ForEach(["High", "Normal", "Low"], id: \.self) { priority in
                        Text(priority)
                    }
                }
                .frame(maxWidth: .infinity)
                .pickerStyle(.segmented)
            }
            Section("Due Date") {
                Toggle("Schedule Time", isOn: $scheduleTime)
                DatePicker("Due Date", selection: $dueDate, in: Date()..., displayedComponents: displayComps())
            }
            
            Button("Save") {
                saveAction()
            }
            .disabled(name == "")
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    func displayComps() -> DatePickerComponents {
        return scheduleTime ? [.hourAndMinute, .date] : [.date]
    }
    
    func saveAction() {
        if let taskItem = taskItem {
            taskViewModel.updateTask(id: taskItem.id!, name: name, desc: desc, priority: priority, dueDate: dueDate, scheduleTime: scheduleTime, viewContext: viewContext)
        } else {
            taskViewModel.createNewTask(name: name, desc: desc, priority: priority, dueDate: dueDate, scheduleTime: scheduleTime, viewContext: viewContext)
        }
        
        taskViewModel.saveContext(viewContext)
        taskViewModel.fecthTasks()
        dismiss()
    }
}
