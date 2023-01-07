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

    
    func scheduleNotification() {
        // Set the date for 8:00 AM the day before the desired date.
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = 8
        dateComponents.minute = 0
        let triggerDate = calendar.date(from: dateComponents)!

        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "A task is due tommorow"

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: "local_notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

