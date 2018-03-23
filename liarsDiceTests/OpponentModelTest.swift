//
//  OpponentModelTest.swift
//  liarsDiceTests
//
//  Created by M. Gao on 21/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import XCTest
@testable import liarsDice

class OpponentModelTest: XCTestCase {
    
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
        //var model = OpponentModel(game: LiarsDiceGame(pName: "test player"))
        var model = OpponentModel(game: LiarsDiceGame(pName: "Erty"))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
