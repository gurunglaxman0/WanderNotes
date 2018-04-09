//
//  NotesTableViewControllerTests.swift
//  WanderNotesUITests
//
//  Created by Lakshman Gurung on 09/04/18.
//  Copyright © 2018 Lakshman Gurung. All rights reserved.
//

import XCTest

class NotesTableViewControllerTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    
    func test_numberOfNotes() {
       let app =  XCUIApplication()
       XCTAssertEqual(app.tables.cells.count , 4)
        
    }
    
    func test_addNewNote() {
        
        let app = XCUIApplication()
        app.navigationBars["Notes"].buttons["Add"].tap()
        app.otherElements.containing(.navigationBar, identifier:"Add New Note").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
        
        let element = app.otherElements.containing(.navigationBar, identifier:"Add New Note").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        let textView = element.children(matching: .textView).element
        textView.tap()
        textView.typeText("Testing")
        element.tap()
    
        XCUIApplication().navigationBars["Add New Note"].buttons["Save"].tap()
        XCTAssertEqual(app.tables.cells.count , 5)
        
    }
    
    
    func test_addNewNoteValidate() {
        
        let app = XCUIApplication()
        app.navigationBars["Notes"].buttons["Add"].tap()
        app.otherElements.containing(.navigationBar, identifier:"Add New Note").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
        
        let element = app.otherElements.containing(.navigationBar, identifier:"Add New Note").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        let textView = element.children(matching: .textView).element
        textView.tap()
        textView.typeText("This is UI Testing")
        element.tap()
        
        XCUIApplication().navigationBars["Add New Note"].buttons["Save"].tap()
        XCTAssertEqual(app.tables.cells.count , 5)
        let lastIndex = app.tables.cells.count - 1
        let tablesQuery = XCUIApplication().tables
        let lastCell = tablesQuery.cells.element(boundBy: lastIndex)
        
       XCTAssertTrue(lastCell.staticTexts["This is UI Testing"].exists)

        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
