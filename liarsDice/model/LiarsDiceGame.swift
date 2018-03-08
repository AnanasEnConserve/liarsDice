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
    // todo: make these private
    func normalizeBid(bid: String) -> String{
        // replace 1 with 7 for sorting purposes
        let newBid = bid.replacingOccurrences(of: "1", with: "7")
        var counts: [Character:Int] = [:]
        for i in newBid {
            counts[i] = (counts[i] ?? 0) + 1
        }
        // I know this is a mess but it works! Sorts by (1) number of occurrences and (2) value if they both appear equally often
        let result = counts.sorted { if($0.value != $1.value){ return $0.value > $1.value} else {return $0.key > $1.key}}.map {String.init(repeating: $0.key, count: $0.value)}
        return result.joined().replacingOccurrences(of: "7", with: "1")
    }
    func calculateRank(bid: String){
        let normalizedBid = normalizeBid(bid: bid)
        print("normalized bid: " + normalizedBid)
        var pattern = [Int]()
        var currentCount = 0
        for i in 0..<normalizedBid.count{
            if i == 0 || normalizedBid[i] == normalizedBid[i-1] {
                currentCount += 1
            }
            else{
                pattern.append(currentCount)
                currentCount = 1
            }
        }
        pattern.append(currentCount)
        print(pattern)
    }
    
    // returns true if the bid is higher, meaning that it is a valid bid
    func bidIsHigher() -> Bool {
        return true
    }
    
    
}
