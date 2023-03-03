//
//  TaskViewModel.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 05/01/2023.
//

import Foundation
import SwiftUI
import CoreData
import UserNotifications

class TaskViewModel: ObservableObject {
    @Published var selectedFilter = TaskFilter.All
    @Published var selectedTaskItem: TaskItem?
    @Published var date = Date()
    @Published var taskItems: [TaskItem] = []
    
    let container = PersistenceController.shared.container
    
    init() {
        fecthTasks()
    }
    
    func fecthTasks() {
        let request = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        request.sortDescriptors = sortOrder()
        
        do {
            taskItems = try container.viewContext.fetch(request)
        }
        catch let error {
            fatalError("Unresolved error \(error)")
        }
    }
    
    private func sortOrder() -> [NSSortDescriptor] {
        let completedDateSort = NSSortDescriptor(keyPath: \TaskItem.completedDate, ascending: true)
        let timeSort = NSSortDescriptor(keyPath: \TaskItem.scheduleTime, ascending: true)
        let dueDateSort = NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)
        
        return [completedDateSort, timeSort, dueDateSort]
    }
    
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            fecthTasks()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func saveAction(id: UUID, created: Date, name: String, desc: String, priority: String, dueDate: Date, scheduleTime: Bool, completion: (_ task: TaskItem)-> Void) {
        withAnimation {
            if selectedTaskItem == nil {
                selectedTaskItem = TaskItem(context: container.viewContext)
            }
            selectedTaskItem?.id = UUID()
            selectedTaskItem?.created = Date()
            selectedTaskItem?.name = name
            selectedTaskItem?.desc = desc
            selectedTaskItem?.priority = priority
            selectedTaskItem?.dueDate = dueDate
            selectedTaskItem?.scheduleTime = scheduleTime
            
            saveContext(container.viewContext)
            
            if let selectedTaskItem = selectedTaskItem {
                completion(selectedTaskItem)
            }
                    }
    }
    
    func filteredTaskItems() -> [TaskItem] {
        if selectedFilter == TaskFilter.Completed {
            return taskItems.filter {$0.isCompleted()}
        }
        
        if selectedFilter == TaskFilter.NonCompleted {
            return taskItems.filter {!$0.isCompleted()}
        }
        
        if selectedFilter == TaskFilter.OverDue {
            return taskItems.filter {$0.isOverdue()}
        }
        
        return taskItems
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { taskItems[$0] }.forEach(container.viewContext.delete)
            
            saveContext(container.viewContext)
        }
    }
    
    func scheduleNotification(task: TaskItem) {
        // Configuring the notification content
        let content = UNMutableNotificationContent()
        content.title = "Task awaiting: \(task.name ?? "Sing")"
        content.body = "Due date: \(task.dueDate ?? Date())"
        
        // Configure the recurring date.
        let calendar = Calendar.current

        // notify 1hour before deadline
        let justBeforeDueDate = calendar.date(byAdding: .hour, value: -1, to: task.dueDate ?? Date())
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: justBeforeDueDate ?? Date())
       
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: false)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: task.id?.uuidString ?? uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
        
    }
}

