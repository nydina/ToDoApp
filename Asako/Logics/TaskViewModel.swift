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
    let container = PersistenceController.shared.container
    
    @Published var date = Date()
    @Published var selectedFilter = TaskFilter.All
    @Published var taskItems: [TaskItem] = []
    
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
    
    
    func scheduleNotification(task: TaskItem) {
        let notificationCenter = UNUserNotificationCenter.current()
        let identifier = task.id?.uuidString ?? UUID().uuidString
        
        // Remove any existing notification requests for the task
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // Check if the task is completed before scheduling a notification
        guard task.completedDate == nil else {
            return
        }
        
        // Configure the notification content
        let content = UNMutableNotificationContent()
        content.title = "A task is due"
        content.body = "\(task.name!), due for: \(task.dueDate!)"
        
        // Configure the trigger for the notification
        let calendar = Calendar.current
        let justBeforeDueDate = calendar.date(byAdding: .hour, value: -1, to: task.dueDate ?? Date())
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: justBeforeDueDate ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
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

