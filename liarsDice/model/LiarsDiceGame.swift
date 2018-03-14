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
    private var human = Player("Player")
    private var opponent = Player("Dumb AI")
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
    // turn count
    private var turnCount = 0
    // initialize the game: put the dices on the table, basically
    init() {
        for _ in 0..<NUMBER_OF_DICE {
            dice.append(Dice())
        }
    }
    
    // BASIC DICE FUNCTIONS ----------------------------------------------------------------
    
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
    
    // OVERALL GAME MECHANICS ----------------------------------------------------------------
    func reset(){
        lastBidRank = 0
        normalizedLastBid = ""
        playerturn = true
        fixed = 0
        for i in dice{
            i.reset()
        }
    }
    
    func incrementTurnCount(){
        turnCount += 1
    }
    
    func getTurnCount() -> Int {
        return turnCount
    }
    
    // Toggles the turn and returns true if it is now the player's turn, false if it is the opponent's turn
    func toggleTurn() -> Bool{
        playerturn = !playerturn
        return self.playerturn
    }
    
    // STUFF ABOUT BIDDING AND RANKING --------------------------------------------------------
    // (this stuff is bad and ugly but works)
    
    private func normalizeBid(_ bid: String) -> String{
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
    
    
    func getLastBid() -> String {
        return normalizedLastBid
    }
    func getLastBidRank() -> Int {
        return lastBidRank
    }
    
    private func getAllDiceValues() -> String{
        var values = String()
        for i in 0..<NUMBER_OF_DICE{
            values.append(String(getDiceNumber(i)))
        }
        return values
    }
    
    /**
     * compares the last bid to the current state of dice
     * returns true if it was a bluff indeed
     */
    func callBluff() -> Bool {
        // instead of comparing the ranks etc compare dice directly by removing them one by one from the pattern
        var dice = getAllDiceValues()
        print("Dice values: ")
        print(dice)
        print("Bid: ")
        print(normalizedLastBid)
        for i in getLastBid() {
            if(dice.contains(i)){
                if let index = dice.index(of: i) {
                    dice.remove(at: index)
                }
            } else {
                // this case means that one dice value in the bid wasn't found in the actual bid so it was a bluff
                print("Caught bluffing!")
                return true
            }
        }
        // if all are removed it was not a bluff
        print("Not a bluff")
        return false
    }
    
    // rocket science
    // check if a bid is the highest possible bid for a rank (so that bidding on that rank on next turn will be impossible)
    func isHighestOfRank() -> Bool {
        switch lastBidRank {
        case 0:
            return getLastBid().starts(with: "1")
        case 1:
            return getLastBid().starts(with: "11")
        case 2:
            return getLastBid().starts(with: "1166")
        case 3:
            return getLastBid().starts(with: "111")
        case 4:
            return getLastBid().starts(with: "11166")
        case 5:
            return getLastBid().starts(with: "1111")
        case 6:
            return getLastBid().starts(with: "11111")
        default:
            return false
        }
    }
    
    
}
