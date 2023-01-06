//
//  DateHolder.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 05/01/2023.
//

import Foundation
import SwiftUI
import CoreData

class DateHolder: ObservableObject {
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
    
    //    @MainActor func reload(_ context: NSManagedObjectContext) {
    //         do {
    //             taskItems = refreshTaskItems(context)
    //         } catch let error {
    //             fatalError("Unresolved error \(error)")
    //         }
    //     }
}
