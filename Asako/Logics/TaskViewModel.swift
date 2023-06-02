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

// View model for managing tasks
class TaskViewModel: ObservableObject {
    let container = PersistenceController.shared.container // Core Data persistent container
    
    @Published var selectedTaskItem: TaskItem? // Currently selected task item
    @Published var date = Date() // Selected date for filtering tasks
    @Published var selectedFilter = TaskFilter.All // Selected filter for tasks
    @Published var taskItems: [TaskItem] = [] // Array of task items
    
    init() {
        fecthTasks() // Fetch tasks from Core Data during initialization
    }
    
    // Filter task items based on the selected filter
    func filterTaskItems() -> [TaskItem] {
        switch selectedFilter {
        case .Completed:
            return taskItems.filter { $0.isCompleted() }
        case .NonCompleted:
            return taskItems.filter { !$0.isCompleted() }
        case .OverDue:
            return taskItems.filter { $0.isOverdue() }
        case .All:
            return taskItems
        }
    }
    
    // Create a new task with the provided parameters
    func createNewTask(name: String, desc: String, priority: String, dueDate: Date, scheduleTime: Bool, viewContext: NSManagedObjectContext) {
        let taskItem = TaskItem(context: viewContext)
        taskItem.id = UUID()
        taskItem.created = Date()
        taskItem.name = name
        taskItem.desc = desc
        taskItem.priority = priority
        taskItem.dueDate = dueDate
        taskItem.scheduleTime = scheduleTime
        scheduleNotification(task: taskItem) // Schedule a notification for the new task
        saveContext(viewContext) // Save the context and fetch updated tasks
    }
    
    // Update an existing task with the provided parameters
    func updateTask(id: UUID, name: String, desc: String, priority: String, dueDate: Date, scheduleTime: Bool, viewContext: NSManagedObjectContext) {
        if let taskItem = taskItems.first(where: { $0.id == id }) {
            taskItem.name = name
            taskItem.desc = desc
            taskItem.priority = priority
            taskItem.dueDate = dueDate
            taskItem.scheduleTime = scheduleTime
            scheduleNotification(task: taskItem) // Update the scheduled notification for the task
            saveContext(viewContext) // Save the context and fetch updated tasks
        }
    }
    
    // Fetch tasks from Core Data
    func fecthTasks() {
        let request = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        request.sortDescriptors = sortOrder() // Apply the specified sort order
        
        do {
            taskItems = try container.viewContext.fetch(request) // Fetch tasks from Core Data
        } catch let error {
            fatalError("Unresolved error \(error)")
        }
    }
    
    // Save changes to Core Data context
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save() // Save the context
            fecthTasks() // Fetch updated tasks
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // Define the sort order for fetching tasks
    private func sortOrder() -> [NSSortDescriptor] {
        let completedDateSort = NSSortDescriptor(keyPath: \TaskItem.completedDate, ascending: true)
        let timeSort = NSSortDescriptor(keyPath: \TaskItem.scheduleTime, ascending: true)
        let dueDateSort = NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)
        
        return [completedDateSort, timeSort, dueDateSort]
    }
    
    // Delete a single task item from the context
    func deleteTaskItem(offsets: IndexSet, context: NSManagedObjectContext) {
        let task = offsets.map { filterTaskItems()[$0]}
        let notificationCenter = UNUserNotificationCenter.current()
        let identifier = task.first?.id?.uuidString ?? UUID().uuidString
        
        // Remove any existing notification requests for the task
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        withAnimation {
            // Delete the task item corresponding to the provided offset from the context
            offsets.map { filterTaskItems()[$0] }.forEach(context.delete)
            saveContext(context) // Save the context and fetch updated tasks
        }
    }

    // Schedule a notification for a task
    func scheduleNotification(task: TaskItem) {
        let notificationCenter = UNUserNotificationCenter.current()
        let identifier = task.id?.uuidString ?? UUID().uuidString

        // Configure the notification content
        let content = UNMutableNotificationContent()
        content.title = "A task is due"
        content.body = "\(task.name!), due for: \(task.dueDate!)"

        // Configure the trigger for the notification
        let calendar = Calendar.current
        let justBeforeDueDate = calendar.date(byAdding: .hour, value: -1, to: task.dueDate ?? Date())
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: justBeforeDueDate ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // Remove any existing notification requests for the task
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])

        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Schedule the new request with the system
        notificationCenter.add(request) { (error) in
            if let error = error {
                // Handle any errors.
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }

}
