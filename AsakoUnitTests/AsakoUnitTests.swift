//
//  AsakoUnitTests.swift
//  AsakoUnitTests
//
//  Created by Dina Andrianarijaona on 03/03/2023.
//
import CoreData
import SwiftUI
import XCTest
@testable import Asako

final class AsakoUnitTests: XCTestCase {
    let viewContext = PersistenceController.shared.container.viewContext

    override func setUpWithError() throws {
    
    }
    
    func testSaveAction() throws {
        let viewModel = TaskViewModel()
        
        let id = UUID()
        let created = Date()
        let name = "Keep learning"
        let desc = "Stay courageous while having questions"
        let priority = "High"
        let dueDate = Date()
        let scheduleTime = false

        viewModel.saveAction(id: id, created: created, name: name, desc: desc, priority: priority, dueDate: dueDate, scheduleTime: scheduleTime, completion: {task in })
        
        XCTAssertEqual(viewModel.taskItems.count, 1)
    }

}
