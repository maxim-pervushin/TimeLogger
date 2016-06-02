//
//  HyperTimeLoggerUISnapshots.swift
//  HyperTimeLoggerUISnapshots
//
//  Created by Maxim Pervushin on 29/03/16.
//  Copyright © 2016 Maxim Pervushin. All rights reserved.
//

import XCTest

class HyperTimeLoggerUISnapshots: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMakeSnapshots() {
        
        let app = XCUIApplication()
        
        waitFor(app.buttons["Settings"], seconds: 1)
        app.buttons["Settings"].tap()
        
        // Settings Screen
        snapshot("04_Settings")
        // Generate Test Data
        app.tables.elementBoundByIndex(0).cells.elementBoundByIndex(0).tapWithNumberOfTaps(7, numberOfTouches: 2)
        app.buttons["Done"].tap()

        // Reports List Screen
        snapshot("01_Reports")
        app.buttons["AddReportButton"].tap()

        // Add Report Screen
        app.textFields["TextField"].tapWithNumberOfTaps(7, numberOfTouches: 2)//typeText("Sleep")
        app.collectionViews["Categories"].cells.elementBoundByIndex(0).tap()
        snapshot("02_AddReport")
        
        app.buttons["Save"].tap()

        // Reports List Screen
        app.buttons["Statistics"].tap()
        
        // Statistics Screen
        snapshot("03_Statistics")
    }
    
    func waitFor(element:XCUIElement, seconds waitSeconds:Double) {
        let exists = NSPredicate(format: "exists == 1")
        expectationForPredicate(exists, evaluatedWithObject: element, handler: nil)
        waitForExpectationsWithTimeout(waitSeconds, handler: nil)
    }
}
