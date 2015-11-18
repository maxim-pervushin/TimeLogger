//
//  HyperTimeLogger_AlphaUITests.swift
//  HyperTimeLogger AlphaUITests
//
//  Created by Maxim Pervushin on 16/11/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import XCTest

class HyperTimeLogger_AlphaUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["Blah"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func enumChildren(element: XCUIElement) {
        print("\(element.elementType)")
        let allChildren = element.childrenMatchingType(.Any).allElementsBoundByIndex
        for current in allChildren {
            enumChildren(current)
        }
    }
    
    func testExample() {
        let app = XCUIApplication()
        app.buttons["CreateCustomMark"].tap()
        
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("New ")
        app.textFields["Title"].typeText("Mark ")
        app.textFields["Title"].typeText("Title")
        
        app.textFields["Subtitle"].tap()
        app.textFields["Subtitle"].typeText("New Mark Subtitle")
        
        app.buttons["Purple"].tap()
        app.buttons["Save"].tap()
        
        
//        let app = XCUIApplication()
//        app.buttons["CreateCustomMark"].tap()
//        
//        let shiftButton = app.buttons["shift"]
//        shiftButton.tap()
//        
//        let tablesQuery = app.tables
//        let titleTextField = tablesQuery.textFields["Title"]
//        titleTextField.typeText("New ")
//        shiftButton.tap()
//        titleTextField.typeText("Mark ")
//        shiftButton.tap()
//        titleTextField.typeText("Title")
//        tablesQuery.buttons["Deep Purple"].tap()
//        app.navigationBars["Edit Report"].buttons["\U0421\U043e\U0445\U0440\U0430\U043d\U0438\U0442\U044c"].tap()
        
    }
    
    func test_createMark() {
        let app = XCUIApplication()
        app.buttons["Road"].tap()
        app.buttons["Work"].tap()

        
//        let collectionViewsQuery = XCUIApplication().collectionViews
//        collectionViewsQuery.buttons["Road "].tap()
//        collectionViewsQuery.buttons["Work "].tap()
        
        
    }
}
