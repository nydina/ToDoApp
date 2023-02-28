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

    
    func scheduleNotification(task: TaskItem) {
        // Configuring the notification content
        let content = UNMutableNotificationContent()
        content.title = "A task is due"
        content.body = "\(task.name!), due for: \(task.dueDate!)"
        
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

