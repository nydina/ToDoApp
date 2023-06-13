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
    private let container: NSPersistentContainer
    private let userNotificationCenter: UNUserNotificationCenter
    
    @Published var selectedTaskItem: TaskItem? // Currently selected task item
    @Published var date = Date() // Selected date for filtering tasks
    @Published var selectedFilter = TaskFilter.All // Selected filter for tasks
    @Published var taskItems: [TaskItem] = [] // Array of task items
    
    // Initialize the view model with the persistent container and user notification center
    init(container: NSPersistentContainer, userNotificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.container = container
        self.userNotificationCenter = userNotificationCenter
        
        fetchTasks()
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
    
    func createNewTask(name: String, desc: String, priority: String, dueDate: Date, scheduleTime: Bool) {
        guard !name.isEmpty else {
            // Empty task name is not allowed, return early
            return
        }
        let taskItem = TaskItem(context: container.viewContext)
        taskItem.id = UUID()
        taskItem.created = Date()
        taskItem.name = name
        taskItem.desc = desc
        taskItem.priority = priority
        taskItem.dueDate = dueDate
        taskItem.scheduleTime = scheduleTime
        scheduleNotification(task: taskItem) // Schedule a notification for the new task
        saveContext() // Save the context and fetch updated tasks
    }
    
    
    // Update an existing task with the provided parameters
    func updateTask(id: UUID, name: String, desc: String, priority: String, dueDate: Date, scheduleTime: Bool) {
        if let taskItem = taskItems.first(where: { $0.id == id }) {
            taskItem.name = name
            taskItem.desc = desc
            taskItem.priority = priority
            taskItem.dueDate = dueDate
            taskItem.scheduleTime = scheduleTime
            scheduleNotification(task: taskItem) // Update the scheduled notification for the task
            saveContext() // Save the context and fetch updated tasks
        }
    }
    
    // Fetch tasks from Core Data
    func fetchTasks() {
        let request = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        request.sortDescriptors = sortOrder() // Apply the specified sort order
        
        do {
            taskItems = try container.viewContext.fetch(request) // Fetch tasks from Core Data
        } catch let error {
            fatalError("Unresolved error \(error)")
        }
    }
    
    // Save changes to Core Data context
    func saveContext() {
        do {
            try container.viewContext.save() // Save the context
            fetchTasks() // Fetch updated tasks
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
    func deleteTaskItem(offsets: IndexSet) {
        let task = offsets.map { filterTaskItems()[$0]}
        
        let identifier = task.first?.id?.uuidString ?? UUID().uuidString
        
        // Remove any existing notification requests for the task
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        withAnimation {
            // Delete the task item corresponding to the provided offset from the context
            offsets.map { filterTaskItems()[$0] }.forEach(container.viewContext.delete)
            saveContext() // Save the context and fetch updated tasks
        }
    }
    
    // Schedule a notification for a task
    func scheduleNotification(task: TaskItem) {
        
        //        let notificationCenter = UNUserNotificationCenter.current()
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
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule the new request with the system
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                // Handle any errors.
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}
