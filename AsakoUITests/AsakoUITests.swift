//
//  AsakoUITests.swift
//  AsakoUITests
//
//  Created by Dina Andrianarijaona on 02/03/2023.
//

import XCTest

final class AsakoUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
        
        
    }
    
    func testInitialListView() throws {
        let navBarTitle = app.navigationBars["To Do List"]
        XCTAssert(navBarTitle.exists)
        
        app.navigationBars.element.buttons["All"].tap()
        
        app.buttons["To Do"].tap()
        
        app.navigationBars.element.buttons["To Do"].tap()
        app.buttons["Completed"].tap()
        
        app.navigationBars.element.buttons["Completed"].tap()
        app.buttons["Overdue"].tap()
        
        app.navigationBars.element.buttons["Overdue"].tap()
        app.buttons["All"].tap()
        
        
        XCTAssert(app.otherElements.buttons["Add new task"].exists)
        
    }
    
    func testEditView() throws {
        // Count the number of rows in the list before adding a new task
        let rowCount = app.collectionViews.cells.count
        
        // Hit on the Add new task button
        app.otherElements.buttons["Add new task"].tap()
        
        // check if back button exists
        XCTAssert(app.navigationBars.buttons["To Do List"].exists)
        
        // check if share task button exists
        XCTAssert(app.navigationBars.buttons["shareTask"].exists)
        
        // make sure ShareLink is not enabled unless conditions are filled (task title filled in + schedule time enabled)
        XCTAssertFalse( app.navigationBars.buttons["shareTask"].isEnabled)
        
        XCTAssert(app.buttons["Save"].exists)
        
        // make sure Save button won't be clickable unless task name is filled
        XCTAssertFalse( app.buttons["Save"].isEnabled)
        
        app.textFields["Task name"].tap()
        app.textFields["Task name"].typeText("test")
        
        app.textFields["Task description"].tap()
        app.textFields["Task description"].typeText("test")
        
        app.buttons["Normal"].tap()
        
        app.switches["Schedule Time"].tap()
        
        XCTAssert(app.datePickers.firstMatch.exists)
        
        XCTAssertTrue(app.buttons["Save"].isEnabled)
        XCTAssertTrue(app.navigationBars.buttons["shareTask"].isEnabled)
        
        app.buttons["Save"].tap()
        
        // Come back to the list view
        XCTAssert(app.navigationBars["To Do List"].waitForExistence(timeout: 2))
        
        // Check if Save button actually added the task
        XCTAssertEqual(app.collectionViews.cells.count, rowCount + 1)
        
        // Delete added row
        app.collectionViews.cells.element.firstMatch.swipeLeft()
        app.buttons["Delete"].tap()
        
        // Check if "No task to date" appear when there is no todo
        XCTAssert(app.staticTexts["No task to date"].exists)
    }
    
}
