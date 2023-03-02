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
        
        XCTAssert(app.staticTexts["No task to date"].exists)

        let addButton = app.otherElements.buttons["Add new task"]
        XCTAssert(addButton.exists)
        
        XCTAssert(app.staticTexts["No task to date"].exists)

        
    }
    
}
