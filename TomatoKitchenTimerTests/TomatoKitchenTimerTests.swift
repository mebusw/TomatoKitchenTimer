//
//  BigTimerTests.swift
//  BigTimerTests
//
//  Created by JackyShen on 16/5/24.
//  Copyright © 2016年 JackyShen. All rights reserved.
//

import XCTest


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
        
        XCTAssertEqual(12 * 3600 + 34 * 60 + 56, timerCore.targetSeconds)
    }

    func testValidateNumberPairs() {
        timerCore.put(7)
        XCTAssertEqual(7, timerCore.targetSeconds)
        
        timerCore.put(8)
        XCTAssertEqual(59, timerCore.targetSeconds)
        
        timerCore.put(1)
        XCTAssertEqual(7 * 60 + 59, timerCore.targetSeconds)

        timerCore.put(2)
        XCTAssertEqual(59 * 60 + 12, timerCore.targetSeconds)

    }

    func testSecondsToDisplayable() {
        XCTAssertEqual("00:02", timerCore.secToDisplayable(2))
        XCTAssertEqual("01:02", timerCore.secToDisplayable(62))
        XCTAssertEqual("01:01:02", timerCore.secToDisplayable(3662))
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
