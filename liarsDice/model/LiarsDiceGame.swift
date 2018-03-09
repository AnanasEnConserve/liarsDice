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
    // The bid made by the previous player; it should always be saved in the "normalized" form,
    // meaning that the dice values are sorted by frequency and value
    private var normalizedLastBid = ""
    private var lastBidRank = 0
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
    func normalizeBid(_ bid: String) -> String{
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
    
    func calculateRank(_ bid: String) -> Int{
        let normalizedBid = normalizeBid(bid)
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
        var convertedPattern = pattern.map({String($0)}).filter({$0 != "1"}).joined()
        // if it is high card, the pattern would be all 1, which get removed. In this case restore a 1
        if convertedPattern == "" {
            convertedPattern = "1"
        }
        print("Pattern type: " + convertedPattern)
        switch convertedPattern {
        case EBid.highCard.rawValue:
            return 0
        case EBid.onePair.rawValue:
            return 1
        case EBid.twoPair.rawValue:
            return 2
        case EBid.threeOfAKind.rawValue:
            return 3
        case EBid.fullHouse.rawValue:
            return 4
        case EBid.fourOfAKind.rawValue:
            return 5
        case EBid.fiveOfAKind.rawValue:
            return 6
        default:
            return -1
        }
    }
    
    // true if the new bid is higher than the old one despite being of the same rank, e.g. 55 vs 44
    // ONLY WELL DEFINED IF THEY ARE ACTUALLY THE SAME RANK
    // Do not use to compare a two pair pattern to a full house pattern etc
    // 2lazy4defensiveprogramming
    private func compareSameRank(_ normalizedNewBid: String) -> Bool {
        // compare the patterns as long as they are both not empty (since 22 can be a bid, but also 221, they can have different lengths)
        for i in 0..<min(normalizedNewBid.count,normalizedLastBid.count){
            if normalizedLastBid[i] == normalizedNewBid[i] {
                continue
            }
            else {
                 return normalizedNewBid.replacingOccurrences(of: "1", with: "7") > normalizedLastBid.replacingOccurrences(of: "1", with: "7")
            }
        }
        // if the function hasn't returned yet, they are equal where they are defined, and the new bid simply has to be longer than the old one
        return normalizedNewBid.count > normalizedLastBid.count
    }
    
    // returns true if the bid is higher, meaning that it is a valid bid
    // also returns the rank
    func bidIsHigher(_ newBid : String) -> (Bool,Int) {
        let normalizedBid = normalizeBid(newBid)
        let newBidRank = calculateRank(newBid)
        if newBidRank > lastBidRank{
            return (true,newBidRank)
        }
        else if newBidRank < lastBidRank{
            return (false,newBidRank)
        }
        else {
            return (compareSameRank(normalizedBid),newBidRank)
        }
    }
    
    func setBid(_ newBid : String) {
        let normalizedBid = normalizeBid(newBid)
        let (isHigher,newRank) = bidIsHigher(newBid)
        if isHigher {
            normalizedLastBid = normalizedBid
            lastBidRank = newRank
        }
        else {
            // todo replace with proper exception?
            print("WARNING: Could not set bid because it was invalid (doesn't rank higher than current one)")
        }
    }
    
}
