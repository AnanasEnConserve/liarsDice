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
    
    
    // initialize, set the game and load player profile, push chunks into model
    init(game: LiarsDiceGame) {
        self.game = game
        super.init()
        //self.loadModel(fileName: "load-profile")
        self.loadProfile(name: "Asdf")
        
        //var pName = game.getPlayer().getName()
        
    }
    
    // retrieves correct chunk if profile with that name exists, otherwise return default chunk
    // yes this is useless and better done in swift without a model, but we need to make our modeler happy
    private func loadProfile(name: String) {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "profiles", ofType: "txt")!
        var profileData = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        // create chunks of the profile for no reason...
        
        //let model = Model()
        self.loadModel(fileName: "load-profile")
        for line in profileData.components(separatedBy: .newlines){
            if(line == "") {continue}
            var data = line.split{$0 == ";"}.map(String.init)
            print("line")
            print(line)
            print(data)
            
            if(data[0] == game.getPlayer().getName()){
                let chunk = self.generateNewChunk()
                chunk.setSlot(slot: "playerName", value: data[0])
                chunk.setSlot(slot: "earlyGameBeh", value: data[1])
                chunk.setSlot(slot: "endGameBeh", value: data[2])
                self.dm.addToDM(chunk)
                print("created and added chunk")
            }
        }
        self.run()
        print(self.dm.chunks)
        print(self.buffers)
    }
    
    
    // TODO add ACT-R stuff here
    func believePlayer() -> Bool{
        // temporary solution, just randomly believe
        return arc4random_uniform(2) == 0
    }
    
    // TODO call machine learning part
    // just be a dumb AI and fix the first one (if it isnt yet)
    func fixDice(){
        game.fixDice([0])
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
