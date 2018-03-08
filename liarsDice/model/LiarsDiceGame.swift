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
    // number of dice already taken out of play. Must never exceed 5
    private var fixed = 0
    // initialize the game: put the dices on the table, basically
    init() {
        for _ in 0..<NUMBER_OF_DICE {
            dice.append(Dice())
        }
    }
    // rolls all dice that are still in play
    func rollDice() {
        for d in dice{
            // this check is actually useless because the Dice class already takes care of it
            // but never trust anything, not even your own code
            if d.isInPlay() {
                d.roll()
            }
        }
    }
    
    // returns value of dice number i
    func getDiceNumber(_ i: Int) -> Int{
        return dice[i].getValue()
    }
    func fixDice(_ toFix: [Int]) {
        for i in toFix {
            dice[i].fix()
            fixed += toFix.count
            if(fixed >= 5){
                print("Dude what are you doing, you broke the game (took out all dice)")
            }
        }
    }
    
    func compareRank() {String }
    
}
