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
        snapshot("01_Reports")
        
        app.buttons["AddReportButton"].tap()

        app.textFields["TextField"].typeText("Sleep")
        app.collectionViews.staticTexts.elementBoundByIndex(0).tap()
        snapshot("02_AddReport")
        
        app.buttons["Save"].tap()
        app.buttons["Statistics"].tap()
        snapshot("03_Statistics")
        
        app.buttons["Done"].tap()
        app.buttons["Settings"].tap()
        snapshot("04_Settings")
        
        app.buttons["Done"].tap()
    }
}
