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
        // test a very reasonable first bid with a honest and a bullshitting player
        // note that these tests dont use assertions since there is often no correct answer, check output yourself
        var game = LiarsDiceGame(pName: "HonestPlayer")
        var model = OpponentModel(game: game)
//        game.setBid("4466")
//        print("Do we believe the player?")
//        print(model.believePlayer())
        game = LiarsDiceGame(pName: "Liar")
        model = OpponentModel(game: game)
        game.setBid("1")
        print("Do we believe the player?")
        //print(model.believePlayer())
        print("------------------------------------")
        _ = game.toggleTurn()
        game.rollDice()
        model.believePlayer()
        
        model.believePlayer()
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
