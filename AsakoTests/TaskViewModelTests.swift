//
//  TaskViewModelTests.swift
//  AsakoTests
//
//  Created by Dina RAZAFINDRATSIRA on 12/06/2023.
//

import XCTest
import CoreData
@testable import Asako

class TaskViewModelTests: XCTestCase {
    var viewModel: TaskViewModel!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        // Create an in-memory persistent store
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        // Create the persistent container
        let container = NSPersistentContainer(name: "Asako")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        // Load the persistent store
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Get the managed object context
        mockContext = container.viewContext
        
        // Create the view model with the mock context
        viewModel = TaskViewModel(container: container)
    }
    
    override func tearDown() {
        viewModel = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testCreateNewTask() {
        // Given
        let name = "Test Task"
        let desc = "Test Description"
        let priority = "High"
        let dueDate = Date()
        let scheduleTime = true
        
        let taskCount = viewModel.taskItems.count
        
        // When
        viewModel.createNewTask(name: name, desc: desc, priority: priority, dueDate: dueDate, scheduleTime: scheduleTime)
        
        // Then
        XCTAssertEqual(viewModel.taskItems.count, taskCount + 1, "Task count did not increase by 1")
        
        let createdTask = viewModel.taskItems.first
        XCTAssertNotNil(createdTask, "TaskItem should not be nil")
        XCTAssertEqual(createdTask?.name, name, "Task name did not match")
        XCTAssertEqual(createdTask?.desc, desc, "Task description did not match")
        XCTAssertEqual(createdTask?.priority, priority, "Task priority did not match")
        XCTAssertEqual(createdTask?.dueDate, dueDate, "Task due date did not match")
        XCTAssertEqual(createdTask?.scheduleTime, scheduleTime, "Task schedule time did not match")
    }
    
    func testUpdateTask() {
        // Given
        let taskId = UUID() // Existing task ID
        let name = "Updated Task"
        let desc = "Updated Description"
        let priority = "Normal"
        let dueDate = Date()
        let scheduleTime = true
        
        // Create a sample task and add it to the viewModel's taskItems
        let task = TaskItem(context: mockContext)
        task.id = taskId
        task.name = "Old Task"
        task.desc = "Old Description"
        task.priority = "High"
        task.dueDate = Date()
        task.scheduleTime = true
        viewModel.taskItems = [task]
        
        // When
        viewModel.updateTask(id: taskId, name: name, desc: desc, priority: priority, dueDate: dueDate, scheduleTime: scheduleTime)
        
        // Then
        XCTAssertEqual(task.name, name, "Task name did not match")
        XCTAssertEqual(task.desc, desc, "Task description did not match")
        XCTAssertEqual(task.priority, priority, "Task priority did not match")
        XCTAssertEqual(task.dueDate, dueDate, "Task due date did not match")
        XCTAssertEqual(task.scheduleTime, scheduleTime, "Task schedule time did not match")
    }
    
    func testDeleteTaskItem() {
        // Given
        let task = TaskItem(context: mockContext)
        task.name = "Task to delete"
        viewModel.taskItems = [task]

        // When
        let offsets = IndexSet(integer: 0)
        viewModel.deleteTaskItem(offsets: offsets)

        // Then
        XCTAssertTrue(viewModel.taskItems.isEmpty, "Task items array should be empty")

        // Fetch tasks from the context and update taskItems array
        viewModel.fetchTasks()

        XCTAssertTrue(viewModel.taskItems.isEmpty, "Task items array should still be empty after deletion from context")
    }
}
