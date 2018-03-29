//
//  OpponentModel.swift
//  liarsDice
//
//  Created by M. Gao on 16/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import Foundation
class OpponentModel: Model{
    var game: LiarsDiceGame
    private var playerBluff = 0
    private var playerGul = 0
    private var playerTotalTurnCount = 0
    
    // initialize, set the game and load player profile, push chunks into model
    init(game: LiarsDiceGame) {
        self.game = game
        super.init()
        //self.loadModel(fileName: "load-profile")
        self.loadProfile(name: game.getPlayer().getName())
    }
    
    // loads player data from file if there is any, and initializes the model with it
    private func loadProfile(name: String) {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "profiles", ofType: "txt")!
        var profileData = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        // create chunks of the profile for no reason...
        var foundProfile = false
        //let model = Model()
        for line in profileData.components(separatedBy: .newlines){
            if(line == "") {continue}
            var data = line.split{$0 == ";"}.map(String.init)
            print("line")
            print(line)
            print(data)
            
            self.loadModel(fileName: "play-with-history")
            if(data[0] == game.getPlayer().getName()){
                foundProfile = true
//                let chunk = self.generateNewChunk()
//                chunk.setSlot(slot: "playerName", value: data[0])
//                chunk.setSlot(slot: "earlyGameBeh", value: data[1])
//                chunk.setSlot(slot: "endGameBeh", value: data[2])
//                self.dm.addToDM(chunk)
//                print("created and added chunk")
                playerBluff = Int(data[1])!
                playerGul = Int(data[2])!
                playerTotalTurnCount = Int(data[3])!
                let testStr = "player data: " + String(playerBluff) + " " + String(playerGul) + " " + String(playerTotalTurnCount)
                print(testStr)
                break
            }
        }
        if !foundProfile {
            playerBluff = 0
            playerGul = 0
            playerTotalTurnCount = 0
            let testStr = "player data: " + String(playerBluff) + " " + String(playerGul) + " " + String(playerTotalTurnCount)
            print(testStr)
        }
        self.modifyLastAction(slot: "playerBluff", value: String(playerBluff))
        self.modifyLastAction(slot: "playerGul", value: String(playerGul))
        self.run()
    }
    
    
    private func influence() -> Int{
        if playerTotalTurnCount <= 10 {
            return 1
        }
        else if playerTotalTurnCount <= 20 {
            return 2
        }
        else{
            return 3
        }
    }
    func believePlayer() -> Bool{
        
        let msg = "playerbid: " + String(game.getLastBidRank()) + ", modelbid: 0, fix: " + String(game.getNumberOfFixedDice()) + ", playerBluff: " + String(playerBluff) + ", playerGul: " + String(playerGul) + ", turn: player, influence: " + String(influence())
        print(msg)
        self.modifyLastAction(slot: "playerbid", value: String(game.getLastBidRank()))
        self.modifyLastAction(slot: "modelbid", value: "0")
        self.modifyLastAction(slot: "fix", value: String(game.getNumberOfFixedDice()))
        self.modifyLastAction(slot: "playerBluff", value: String(playerBluff))
        self.modifyLastAction(slot: "playerGul", value: String(playerGul))
        self.modifyLastAction(slot: "turn", value: "player")
        self.modifyLastAction(slot: "influence", value: String(influence()))
        self.run()
        print("BELIEVE PLAYER: ")
        let believe = self.lastAction(slot: "response")
        print(believe)
        self.run()
        return believe != nil && believe! == "believe"
        
    }
    
    // TODO call machine learning part
    // just be a dumb AI and fix the first one (if it isnt yet)
    func fixDice(){
        game.fixDice([0])
    }
    
    // testing
    func makeBid(){
        let msg = "playerbid: " + String(game.getLastBidRank()) + ", modelbid: 0, fix: " + String(game.getNumberOfFixedDice()) + ", playerBluff: " + String(playerBluff) + ", playerGul: " + String(playerGul) + ", turn: model, influence: " + String(influence())
        print(msg)
        self.modifyLastAction(slot: "playerbid", value: String(game.getLastBidRank()))
        self.modifyLastAction(slot: "modelbid", value: String(game.calculateRankOfRoll()))
        self.modifyLastAction(slot: "fix", value: String(game.getNumberOfFixedDice()))
        self.modifyLastAction(slot: "playerBluff", value: String(playerBluff))
        self.modifyLastAction(slot: "playerGul", value: String(playerGul))
        self.modifyLastAction(slot: "turn", value: "model")
        self.modifyLastAction(slot: "influence", value: String(influence()))
        self.waitingForAction = false
        self.run()
        print("WHAT TO BID: ")
        let response = self.lastAction(slot: "response")
        print(response)
        var newBidRank = game.getLastBidRank()
        // model only works if it runs again after response...
        self.run()
        if(response == nil){
            newBidRank += 1
        } else{
            switch response! {
            case "oneh":
                newBidRank += 1
                break
            case "twoh":
                newBidRank += 2
                break
            case "threeh":
                newBidRank += 3
                break
            case "fourh":
                newBidRank += 4
                break
            case "t-bid":
                newBidRank = -1
                break
            default: // lastresort OR model fails and returns nil
                newBidRank += 1
            
            }
        }
        print("new bid rank: " + String(newBidRank))
        game.setBid(createValidBid(rank: newBidRank))
        
    }
    func makeBid2(){
        // very smart bids
        switch game.getLastBidRank() {
        case 0:
            game.setBid("22")
        case 1:
            game.setBid("2233")
        case 2:
            game.setBid("222")
        case 3:
            game.setBid("22233")
        case 4:
            game.setBid("2222")
        default:
            game.setBid("11111")
        }
    }
    // take
    private func createValidBid() -> String{
        var bid = ""
        // the basis of new bid
        var fixed = game.normalizeBid(game.getFixedDice())
        
        
        return bid
    }
    
    
    // makes a bid that is guaranteed to be valid if the input rank is higher (or equal) than the last bid
    // this method does NOT cover all cases (absurd ones such as 4 dice fixed but bid rank 0)
    // in those cases there will still be a bid but there is a chance for them to be impossible due to
    // contradicting the visible dice
    // most of these have a randomness factor for believability, but they do not correspond to the
    // actual probabilities
    // todo make private after testing
    // truthful bids are not checked btw
    public func createValidBid(rank: Int) -> String{
        print("creating bid of higher rank: " + String(rank))
                if rank == -1 {
                    var bid = game.getRoll()
                    var counts: [Character:Int] = [:]
                    for i in bid {
                        counts[i] = (counts[i] ?? 0) + 1
                    }
                    var toFilterOut = ""
                    for idx in counts.keys{
                        if counts[idx] == 1{
                            toFilterOut.append(idx)
                        }
                    }
                    bid = bid.filter {!toFilterOut.contains($0)}
                    return bid
                }
        
        if(rank < game.getLastBidRank()){
            print("create bid of higher rank: invalid rank (lower than last bid)")
        }
        // the bid to be returned
        var bid = ""
        // variables for rolling randoms
        var pairValue = 0
        // variable for keeping track of excluded rolls
        // (eg we want to make 2 pair, first pair is already 22,
        // so when randomly rolling another pair, exclude 2)
        var excluding = 0
        // the basis of new bid is the dice that are already visible (fixed) to the player for plausibility
        // fixed is normalized so that the most frequent value is always at index 0
        let fixed = game.normalizeBid(game.getFixedDice())
        let fixedRank = game.calculateRank(fixed)
        let fixedNumber = game.getNumberOfFixedDice()
        let uniqueFixed = uniqueValuesInBid(bid: fixed) // used to check if full house and above are possible
        var uniqueHigherThan = ""
        let lastBid = game.getLastBid()
        let lastBidRank = game.getLastBidRank()
        let msg = "fixed: " + String(fixed) + " (rank of fixed dice only: " + String(fixedRank) + "; last bid was " + lastBid + " (rank " + String(lastBidRank) + ")"
        print(msg)
        // ugly part begins here, consider all possible cases.
        // some cases are not possible, e.g. 3 dice are fixed and aren't equal, then four/five of a kind
        // are ruled out.
        // also case 0 is never needed in this function since it can't be higher than anything (equal rank bids are somewhere else)
        switch rank {
        // rank 0: ignore fixed dice (why should there be any), just roll higher than last bid
        case 0:
            if(lastBid.length >= 0){
                bid = String(rollHigherThan(n: Int(lastBid[0])!))
            } else {
                bid = String(rollDie())
            }
        case 1: // one pair
            if(lastBidRank == 1){
                uniqueHigherThan = uniqueFixedValuesHigherThan(uniqueBid: fixed, n: Int(lastBid[0])!)
                // if there are fixed dice that are higher in value than the pair, 50% chance of using them
                if(uniqueHigherThan.length > 0 && arc4random_uniform(2) == 0){
                    // beautiful
                    pairValue = chooseRandom(from: uniqueHigherThan)
                } else{
                    pairValue = Int(rollHigherThan(n: Int(lastBid[0])!))
                }
            } else {
                if fixedNumber > 0 {
                
                    pairValue = chooseRandom(from: fixed)
                    // if we have 3 or less dice fixed we can just reroll for any
                    if fixedNumber < 4{
                        // todo: proper math?
                        if arc4random_uniform(100) < 100 - fixedNumber*20{
                            pairValue = Int(rollHigherThan(n: Int(lastBid[0])!))
                        }
                    }
                } else {
                    pairValue = Int(rollHigherThan(n: Int(lastBid[0])!))
                }
                
            }
            bid = String(repeating: String(pairValue), count:2)
            break
            // for rank 2, we check if there is already a pair. If so, add another pair.
            // if there are more than 2 fixed (eg 112) give a higher probability for 1122 than 1133 etc
        case 2: // two pair
            
            if lastBidRank == 2{
                print("LAST BID WAS RANK 2 --------------------")
                // make sure the bid is valid by rolling one higher value
                pairValue = rollHigherThan(n: Int(lastBid[0])!)
                bid = String(repeating: String(pairValue), count: 2)
                // todo have a look at fixed dice?
                bid += String(repeating: String(rollExcept(n: pairValue)), count: 2)
                break
            }
            
            // already a fixed pair
            if fixedRank == 1{
                excluding = Int(fixed[0])!
                if fixedNumber > 2{
                    // guaranteed the first non-pair unless bid was lower than the fixed dice which is bull
                    // and should never happen. Add the case when there is time otherwise leave it
                    pairValue = Int(fixed[2])!
                    if(arc4random_uniform(2) == 0){
                        // note that this can still be the the pair value, so overall odds is above 50%
                        pairValue = rollExcept(n: excluding)
                    }
                }
                else{
                    pairValue = rollExcept(n: excluding)
                }
                bid = fixed.substring(from: 0, to: 2) + String(repeating: String(pairValue), count: 2)
            }
                // guaranteed rank 0 then
            else {
                if(fixedNumber > 0){
                    pairValue = chooseRandom(from: fixed)
                    if fixedNumber < 5{
                        // todo: proper math?
                        if arc4random_uniform(100) < 100 - fixedNumber*10{
                            pairValue = rollDie()
                        }
                    }
                } else{
                    pairValue = rollDie()
                }
                bid = String(pairValue) + String(pairValue)
                // just roll another
                excluding = pairValue
                pairValue = rollExcept(n: excluding)
                bid += String(pairValue) + String(pairValue)
            }
            break
        case 3: // three of a kind
            if (lastBidRank == 3){
                uniqueHigherThan = uniqueFixedValuesHigherThan(uniqueBid: uniqueFixed, n: Int(lastBid[0])!)
                if(uniqueHigherThan.length > 0){
                    pairValue = chooseRandom(from: uniqueHigherThan)
                } else {
                    pairValue = rollHigherThan(n: Int(lastBid[0])!)
                }
                bid = String(repeating: String(pairValue), count:3)
                break
            }
            
            // if we still have at least one fixed and 2 non-fixed, we can take any
            // of the fixed ones and make 3 of them. Note that if 3 are fixed and one is a pair,
            // that one automatically gets better odds
            if fixedNumber > 0 && fixedNumber < 4{
                pairValue = Int(fixed[Int(arc4random_uniform(UInt32(fixedNumber)))])!
                if fixedNumber < 3{
                    // todo: proper math?
                    if arc4random_uniform(100) < 100 - fixedNumber*20{
                        pairValue = rollDie()
                    }
                }
            } else {
                pairValue = rollDie()
            }
            bid = String(repeating: String(pairValue),count: 3)
            break
        case 4: // full house
            // check if there are more than 3 different dice fixed because it means impossible
            if uniqueFixed.length > 2{
                print("PANIC! TRIED TO FULL HOUSE when there are more than 2 fixed dice of different values")
                return "xxxxx"
            }
            if(lastBidRank == 4){
                uniqueHigherThan = uniqueFixedValuesHigherThan(uniqueBid: fixed, n: Int(lastBid[0])!)
                if uniqueHigherThan.length >= 0{
                    pairValue = Int(uniqueHigherThan[0])!
                    
                }
                else{
                    pairValue = rollHigherThan(n: Int(lastBid[0])!)
                }
                bid = String(repeating: String(pairValue), count: 3)
                if uniqueHigherThan.length == 1{
                    bid += String(repeating: uniqueHigherThan[1], count: 2)
                }else {
                    bid += String(repeating: String(rollExcept(n: pairValue)), count: 2)
                }
                break
            }
            
            let random0or1 = Int(arc4random_uniform(2)) //todo maybe make it not 50/50
            if uniqueFixed.length > 0{
            pairValue = Int(uniqueFixed[0])!
            bid = String(repeating: String(pairValue), count: 3 - random0or1)
            if uniqueFixed.length == 1{
                excluding = pairValue
                pairValue = rollExcept(n: excluding)
                bid += String(repeating: String(pairValue), count: 2 + random0or1)
            }
            else if uniqueFixed.length == 2{
                pairValue = Int(uniqueFixed[1])!
                bid += String(repeating: String(pairValue), count: 3 - random0or1)
                }
                
            }
                // 0 fixed, any full house will do
            else {
                pairValue = rollDie()
                bid = String(repeating: String(pairValue), count: 3)
                excluding = pairValue
                bid += String(repeating: String(rollExcept(n: excluding)), count:2)
            }
            break
        case 5: // four of a kind
            if uniqueFixed.length > 2{
                print("HELP HOW CAN I MAKE 4 OF A KIND IF MORE THAN 2 VALUES ARE FIXED")
                return "xxxxx"
            }
            if(lastBidRank == 5){
                uniqueHigherThan = uniqueFixedValuesHigherThan(uniqueBid: uniqueFixed, n: Int(lastBid[0])!)
                if(uniqueHigherThan.length > 0){
                    pairValue = Int(uniqueHigherThan[0])!
                }
                bid = String(repeating: String(pairValue), count: 4)
                break
            }
            if(uniqueFixed.length == 0){
                pairValue = rollDie()
            } else{
                pairValue = Int(uniqueFixed[0])!
            }
            bid = String(repeating: String(pairValue),count: 4)
            break
        case 6: // five of a kind
            if uniqueFixed.length > 1{
                print("HELP I AM HAVING A HEART ATTACK (five of a kind not possible)")
                return "xxxxx"
            }
            
            if(lastBidRank == 5){
                uniqueHigherThan = uniqueFixedValuesHigherThan(uniqueBid: uniqueFixed, n: Int(lastBid[0])!)
                if(uniqueHigherThan.length > 0){
                    pairValue = Int(uniqueHigherThan[0])!
                }
                bid = String(repeating: String(pairValue), count: 4)
                break
            }
            if(uniqueFixed.length == 0){
                pairValue = rollDie()
            } else{
                pairValue = Int(uniqueFixed[0])!
            }
            bid = String(repeating: String(pairValue),count: 5)
            break
        default:
            print("how the fuck did I end up in the default case (createbidofhigherrank)")
            return "xxxxx"
        }
        return bid
    }
    
    private func rollDie() -> Int{
        return Int(arc4random_uniform(UInt32(6))) + 1
    }
    // returns number of unique values in bid
    private func uniqueValuesInBid(bid : String) -> String{
        var set = Set<Character>()
        let uniqueVals = String(bid.filter{ set.insert($0).inserted } )
        return uniqueVals
    }
    private func uniqueFixedValuesHigherThan(uniqueBid: String, n: Int) -> String{
        var result = ""
        for i in 0..<uniqueBid.length{
            if Int(uniqueBid[i])! > n {
                result.append(uniqueBid[i])
            }
        }
        return result
    }
    private func chooseRandom(from list: String) -> Int{
        return Int(list[Int(arc4random_uniform(UInt32(list.length)))])!
    }
    
    // default action for non-truthful
    private func createBidFromDecision(_ newBidRank: Int) -> String{
        
        return ""
    }
//    // THE BIG BLUFF
//    private func createBidFromDecision(_ newBidRank: Int) -> String{
//        var bid = ""
//        // truthful: remove all unique values from roll and call it a bid
//        // eg if roll is 24344 it becomes 444, 12323 becomes 2323
//        if newBidRank == -1 {
//            var counts: [Character:Int] = [:]
//            for i in bid {
//                counts[i] = (counts[i] ?? 0) + 1
//            }
//            var toFilterOut = ""
//            for idx in counts.keys{
//                if counts[idx] == 1{
//                    toFilterOut.append(idx)
//                }
//            }
//            bid = bid.filter {!toFilterOut.contains($0)}
//            return bid
//        }
//
//        // all other cases (including last resort but it's not a special case anymore here,
//        // since its taken care of before function call (see makeBid))
//
//        var newBid = ""
//        bid = game.normalizeBid(game.getFixedDice())
//        var currentRank = game.calculateRank(bid)
//
//        switch newBidRank{
//            // make a bid of rank 0. It means last bid is also rank 0,
//            // so we bid a random number above last bid
//            // TODO there might be cases where the bid is 0 and the model still fixed some dice, needs to be added later (make it above or equal to highest fixed die)
//        case 0:
//            if(game.getLastBid().length > 1 || game.isHighestOfRank()){
//                    print("PANIC - tried to make bid of rank 0 but old bid is already higher rank")
//                    newBid = "11111"
//                    break
//            }
//            newBid = String(self.rollHigherThan(n: Int(game.getLastBid())!))
//            break;
//        case 1: // 1 pair
//                // make a bid of rank 1
//                // if we have a single bid and no fixed dice or just fixed the previous bid, just duplicate
//            if(game.getLastBid().length == 1 && game.getNumberOfFixedDice() == 0 || game.getFixedDice() == game.getLastBid()){
//                    newBid = game.getLastBid() + game.getLastBid()
//                    break
//            }
//            // if we have a pair as a bid already just go higher (TODO: see what fixed dice do)
//            newBid = String(self.rollHigherThan(n: Int(game.getLastBid()[0])!))
//            newBid += newBid
//        case 2: // 2 pair
//            // if previous bid was a pair, just another pair that isnt the same, if was a single then just duplicate
//            // todo: if
//            if(game.getLastBidRank() == 0){
//                newBid = game.getLastBid() + game.getLastBid()
//            }
//            let newNum = rollExcept(n: Int(game.getLastBid()[0])!)
//            newBid += String(newNum) + String(newNum)
//            break
//        case 3: // 3 of a kind
//            // if previous bid was single or pair, just duplicate
//            if(game.getLastBidRank() == 0){
//                newBid = game.getLastBid() + game.getLastBid() + game.getLastBid()
//            }
//            if(game.getLastBidRank() == 1){
//                newBid = game.getLastBid() + game.getLastBid()[0]
//            }
//            // if previous bid was 3 of a kind
//            newBid = String(self.rollHigherThan(n: Int(game.getLastBid()[0])!))
//            newBid += newBid + newBid             // TODO THIS IS GARBAGE
//        case 4: // Full house
//
//        default:
//            print("PANIC - default case reached")
//            newBid = "11111" // PANIC
//
//        }
//
//        return ""
//    }
    
    // cant roll higher than 1
    func rollHigherThan(n: Int) -> Int{
        let bounds = UInt32(7 - n - 1)
        let randomN = Int(arc4random_uniform(bounds))
        let result = n + randomN + 1
        return result == 7 ? 1 : result
    }
    
    func rollExcept(n: Int) -> Int{
        let randomN = Int(arc4random_uniform(5)) + 1
        if randomN >= n{
            return randomN+1
        } else{
            return randomN
        }
    }
    
    
    func calculateTurn(){
        // call bluff and end turn if the player is believed to bluff
        if(!believePlayer()){
            print("The AI calls bullshit on your bid!")
            _ = game.isBidABluff()
            return
        }
        fixDice()
        game.rollDice()
        //makeBid()
        print("i am calculating")
        
        makeBid()
        _ = game.toggleTurn()
        //var chunk = Chunk(s: "name",m: self)
        //chunk.setSlot(slot: <#T##String#>, value: <#T##Value#>)
        
        
        
    }
    
}
