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
        
        snapshot("01_Reports")
        
        XCUIApplication().buttons["AddReportButton"].tap()
        
        snapshot("02_AddReport")
        
        
    }
}
