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
            
            if(data[0] == game.getPlayer().getName()){
                foundProfile = true
                self.loadModel(fileName: "play-with-history")
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
            self.loadModel(fileName: "play-without-history")
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
        
        self.modifyLastAction(slot: "playerbid", value: String(game.getLastBidRank()))
        self.modifyLastAction(slot: "modelbid", value: "0")
        self.modifyLastAction(slot: "fix", value: String(game.getNumberOfFixedDice()))
        self.modifyLastAction(slot: "playerBluff", value: String(playerBluff))
        self.modifyLastAction(slot: "playerGul", value: String(playerGul))
        self.modifyLastAction(slot: "turn", value: "player")
        self.modifyLastAction(slot: "influence", value: String(influence()))
        self.run()
        print("BELIEVE PLAYER: ")
        let believe = self.lastAction(slot: "response")!
        print(believe)
        self.run()
        // when in doubt just believe the player
        return believe == nil || believe == "believe"
        
    }
    
    // TODO call machine learning part
    // just be a dumb AI and fix the first one (if it isnt yet)
    func fixDice(){
        game.fixDice([0])
    }
    
    // testing
    func makeBid2(){
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
        var newBidRank = game.calculateRankOfRoll()
        // model only works if it runs again after response...
        self.run()
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
            if(game.isHighestOfRank()){
                newBidRank += 1
            }
        }
        game.setBid(createBidFromDecision(newBidRank))
        
    }
    func makeBid(){
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
        //makeBid()
        print("i am calculating")
        
        makeBid()
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" + game.getLastBid())
        game.toggleTurn()
        //var chunk = Chunk(s: "name",m: self)
        //chunk.setSlot(slot: <#T##String#>, value: <#T##Value#>)
        
        
        
    }
    
}
