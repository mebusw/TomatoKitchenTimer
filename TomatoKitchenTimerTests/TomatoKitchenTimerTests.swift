//
//  BigTimerTests.swift
//  BigTimerTests
//
//  Created by JackyShen on 16/5/24.
//  Copyright © 2016年 JackyShen. All rights reserved.
//

import XCTest
@testable import TomatoKitchenTimer


class TomatoKitchenTimerTests: XCTestCase {
    var timerCore:TimerCore!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        timerCore = TimerCore()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    

    func testPutMoreThanSixNumbers() {
        timerCore.put(1)
        timerCore.put(2)
        timerCore.put(3)
        timerCore.put(4)
        timerCore.put(5)
        timerCore.put(6)
        XCTAssertEqual([1, 2, 3, 4, 5, 6], timerCore.seq)
        
        timerCore.put(7)
        XCTAssertEqual([2, 3, 4, 5, 6, 7], timerCore.seq)
    }

    func testGenerateNumberPairsAndTotal() {
        timerCore.put(1)
        timerCore.put(2)
        timerCore.put(3)
        timerCore.put(4)
        timerCore.put(5)
        timerCore.put(6)
        
        XCTAssertEqual([12, 34, 56, 12 * 3600 + 34 * 60 + 56], timerCore.generate())
    }

    func testValidateNumberPairs() {
        timerCore.put(7)
        XCTAssertEqual([0, 0, 7, 7], timerCore.generate())
        
        timerCore.put(8)
        XCTAssertEqual([0, 0, 59, 59], timerCore.generate())
        
        timerCore.put(1)
        XCTAssertEqual([0, 7, 59, 7 * 60 + 59], timerCore.generate())

        timerCore.put(2)
        XCTAssertEqual([0, 59, 12, 59 * 60 + 12], timerCore.generate())

    }

    func testSecondsToDisplayable() {
        XCTAssertEqual("00:00:02", timerCore.secToDisplayable(2))
        XCTAssertEqual("00:01:02", timerCore.secToDisplayable(62))
        XCTAssertEqual("01:01:02", timerCore.secToDisplayable(3662))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
