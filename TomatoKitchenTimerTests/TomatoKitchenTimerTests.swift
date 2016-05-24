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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
        let timerCore = TimerCore()
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

    func testGenerateNumberPairsAnd() {
        let timerCore = TimerCore()
        timerCore.put(1)
        timerCore.put(2)
        timerCore.put(3)
        timerCore.put(4)
        timerCore.put(5)
        timerCore.put(6)
        
        XCTAssertEqual([12, 34, 56, 12 * 3600 + 34 * 60 + 56], timerCore.generate())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
