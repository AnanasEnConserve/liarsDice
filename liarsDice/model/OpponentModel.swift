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
        print(self.lastAction(slot: "response"))
        return self.lastAction(slot: "response") == "believe"
    }
    
    // TODO call machine learning part
    // just be a dumb AI and fix the first one (if it isnt yet)
    func fixDice(){
        game.fixDice([0])
    }
    
    func makeBid(){
        self.modifyLastAction(slot: "fix", value: "0")
        self.modifyLastAction(slot: "turn", value: "model")
        self.modifyLastAction(slot: "playerbid", value: "2.0")
        self.modifyLastAction(slot: "modelbid", value: "5")
        self.modifyLastAction(slot: "playerBluff", value: "2")
        self.modifyLastAction(slot: "playerGul", value: "1.0")

//        self.modifyLastAction(slot: "playerbid", value: String(game.getLastBidRank()))
//        self.modifyLastAction(slot: "modelbid", value: String(game.calculateRankOfRoll()))
//        self.modifyLastAction(slot: "fix", value: String(game.getNumberOfFixedDice()))
//        self.modifyLastAction(slot: "playerBluff", value: String(playerBluff))
//        self.modifyLastAction(slot: "playerGul", value: String(playerGul))
//        self.modifyLastAction(slot: "turn", value: "model")
 //       self.modifyLastAction(slot: "influence", value: String(influence()))
        self.waitingForAction = false
        self.run()
        print("WHAT TO BID: ")
        print(self.lastAction(slot: "response"))
        
//        switch game.getLastBidRank() {
//        case 0:
//            game.setBid("22")
//        case 1:
//            game.setBid("2233")
//        case 2:
//            game.setBid("222")
//        case 3:
//            game.setBid("22233")
//        case 4:
//            game.setBid("2222")
//        default:
//            game.setBid("11111")
//        }
    }
    
    func calculateTurn(){
        // call bluff and end turn if the player is believed to bluff
        if(!believePlayer()){
            print("The AI calls bullshit on your bid!")
            _ = game.isBidABluff()
            return
        }
        fixDice()
        makeBid()
        
        //var chunk = Chunk(s: "name",m: self)
        //chunk.setSlot(slot: <#T##String#>, value: <#T##Value#>)
        
        
        
    }
    
}
