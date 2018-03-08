//
//  ViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 22/02/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // model that contains all data
    var game = LiarsDiceGame()
    
    let elements = ["High card", "One pair", "Two pair", "Three of a kind", "Full house", "Four of a kind", "Five of a kind"]
    
    //Declare array of values the dice can take
    var diceValues = ["⚀","⚁","⚂","⚃","⚄","⚅"]
    
    // these should from now on be accessed through the variable 'game'
    //Declare variables to keep track of the score
//    var playerScore = 0
//    var opponentScore = 0
//    var playerStreak = 0
//    var opponentStreak = 0
    
    // The dice buttons displayed on the side, representing the fixed ones
    @IBOutlet var diceTakenOut: [UIButton]!
    // ALL Dice, including the ones taken out. The ones that are taken out are simply set to "hidden" but they are still there
    @IBOutlet var allDice: [UIButton]!
    
    //Array to store all strings as rolled in the current turn
    var currentRoll = [" "," "," "," "," "]
    
    @IBAction func rollDice(_ sender: UIButton) {
        for index in 0...4 {
            allDice[index].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
        }
        rollDice()
    }
    
    //TODO:
    // Only show the 'Hold' button when appropriate (disable it otherwise and possibly hide it/set opacity to 0%)
    // Create animation or something to indicate to the player that the opponent is rolling**
    // If same value is rolled by same dice, the image remains static and it appears the player did not roll (FIX by opacity 0% at the start of the roll?)
    // Create menu to allow the player to register their bid
    // Create menu displaying the opponents bid and allow to Accept/Challenge
    // Create game instructions (start page?)
    
    //Array containing the selected dice
    var selected = [Int]()
    
    //Function to highlight selected dices
    @IBAction func touchDice(_ sender: UIButton) {
        var getIndex = 0
        if let selectedDice = allDice.index(of: sender){
            if selected.contains(selectedDice) == false {
                selected.append(allDice.index(of: sender)!)
                allDice[selectedDice].setTitleColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: UIControlState.normal)
            }
            else {
                while selected[getIndex] != selectedDice {
                    getIndex += 1
                }
                selected.remove(at: getIndex)
                allDice[selectedDice].setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: UIControlState.normal)
            }
        }
            print(selected)
    }
    
    //Array to keep track of which and how many buttons are already taken out
    var removed = [Int]()
    
    //Function to transfer dice from InPlay to TakenOut
    @IBAction func removeDice(_ sender: UIButton) {
        if removed.count + selected.count == 5 {
            print("I'm afraid I can't let you do that Dave")
            return
        }
        // fix dice in the model
        game.fixDice(selected)
        // make the dice disappear in the UI
        for buttonIndex in selected{
            allDice[buttonIndex].isHidden = true
        }
        // todo: is this needed? Also add sanity check?
        removed.append(contentsOf: selected)
        // make them appear in the fixed row
        for i in 0..<selected.count {
            diceTakenOut[removed.count - selected.count + i].setTitle(currentRoll[selected[i]], for: UIControlState.normal)
        }
        // clear selection
        selected.removeAll()
        
//        if removed.count + selected.count == 5 {
//            print("I'm afraid I can't let you do that Dave")
//        }
//        else {
//        //let removedPreviously = removed.count
//            for appending in 0..<selected.count {
//                if removed.contains(selected[appending]) == false {
//                    removed.append(selected[appending])
//                }
//            }
//            print("Array of Removed dice ",removed)
//            for copying in 0..<removed.count {
//                diceTakenOut[copying].setTitle(currentRoll[removed[copying]], for: UIControlState.normal)
//            diceTakenOut[copying].setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControlState.normal)
//        }
//
//        //Make taken out dice disappear;; Revert others back to original color
//            for updateColor in 0...4 {
//                if removed.contains(updateColor) {
//                    diceInPlay[updateColor].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
//                    diceInPlay[updateColor].isEnabled = false
//                } else {
//                    diceInPlay[updateColor].setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: UIControlState.normal)
//                }
//            }
//            selected.removeAll()
//        }
    }
      //TODO: Only allow to Hold once per turn;
    
    
    //Function to reset things at the start of a new round
    func startGame() {
        game = LiarsDiceGame()
        removed.removeAll()
        selected.removeAll()
        for value in 0..<diceTakenOut.count {
            let currentDice = diceTakenOut[value]
            currentDice.setTitle(" ", for: UIControlState.normal)
            currentDice.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
        }
            // if playerStart == false {
        // for value in 0..<diceInPLay.count {
        //diceInPlay[value].setTitleColor(Opacity 0%, for: UIControlState.normal)
            // }
        //}
    }
    
    
    @IBAction func resetGame(_ sender: UIButton) {
        reset()
    }
    
    //Function to reset the game (start new round && reset scores)
    func reset() {
        removed.removeAll()
        selected.removeAll()
        
        //Revert colors && enable buttons for dice
        for index in 0..<allDice.count {
            allDice[index].setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: UIControlState.normal)
            allDice[index].isEnabled = true
            allDice[index].isHidden = false
        }
        
        for value in 0..<diceTakenOut.count {
            diceTakenOut[value].setTitle(" ", for: UIControlState.normal)
            //diceTakenOut[value].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
        }
        
        //TODO: Reset scores
        //Call function startGame() to set up a new round?
    }
    
   
    func rollDice() {
        if removed.count > 0 {
            for index in 0..<currentRoll.count {
                if removed.contains(index) ==  false {
                    currentRoll[index] = " "
                }
            }
        }
      
        
        //DispatchQueue thingy ensures a delay in showing the roll (to possibly allow for an animation to be shown)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            for value in 0..<self.allDice.count {
                if self.removed.contains(value) == false {
                    let currentDice = self.allDice[value]
                let randomValue = Int(arc4random_uniform(6))
                    currentDice.setTitle(self.diceValues[randomValue], for: UIControlState.normal)
                currentDice.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: UIControlState.normal)
                    self.currentRoll[value] = self.diceValues[randomValue]
                //currentRoll.insert(diceValues[randomValue], at: value)
                //currentRoll.append(diceValues[randomValue])
            }
           // else {
             //       self.diceInPlay[value].setTitle(" ", for: UIControlState.normal)
            //}
        }
        })
        for index in 0..<allDice.count {
            allDice[index].setTitle(currentRoll[index], for: UIControlState.normal)
            //diceInPlay[index].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
        }
        
        print("Array of Current Roll: ", currentRoll)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

