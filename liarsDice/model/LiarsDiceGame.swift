//
//  LiarsDiceGame.swift
//  liarsDice
//
//  Created by M. Gao on 07/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import Foundation

class LiarsDiceGame {
    // The players
    private var human = Player()
    private var opponent = Player()
    // The bid made by the previous player
    private var lastBid = ""
    // True if it is the human player's turn
    private var playerturn = true
    // All dice; whether they are still in play or fixed is stored in the Dice objects
    private var dice = [Dice]()
    private var NUMBER_OF_DICE = 5
    init() {
        for _ in 0..<NUMBER_OF_DICE {
            dice.append(Dice())
        }
    }
    
}
