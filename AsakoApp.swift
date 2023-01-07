//
//  AsakoApp.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//

import SwiftUI


@main
struct AsakoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let dateHolder = TaskViewModel()
            
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dateHolder)
        }
    }
    
    private let notificationManager = NotificationManager()

    init() {

        setupNotifications()
    }
    
    private func setupNotifications() {
        notificationManager.notificationCenter.delegate = notificationManager
        notificationManager.handleNotification = handleNotification

        requestNotificationsPermission()
    }
    
    private func handleNotification(notification: UNNotification) {
        print("<<<DEV>>> Notification received: \(notification.request.content.userInfo)")
    }

    private func requestNotificationsPermission() {
        notificationManager.requestPermission(completionHandler: { isGranted, error in
            if isGranted {
                // handle granted success
            }

            if let _ = error {
                // handle error

                return
            }
        })
    }
    
}
