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

    init(game: LiarsDiceGame) {
        self.game = game
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
            _ = game.callBluff()
            return
        }
        fixDice()
        makeBid()
    }
    
}
