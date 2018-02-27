//
//  ViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 22/02/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    //Declare array of values the dice can take
    var diceValues = ["⚀","⚁","⚂","⚃","⚄","⚅"]
    
    //Declare variables to keep track of the score
    var playerScore = 0
    var opponentScore = 0
    var playerStreak = 0
    var opponentStreak = 0
    

    
    @IBOutlet var diceTakenOut: [UIButton]!
    
    
    @IBAction func rollDice(_ sender: UIButton) {
        rollDice()
    }
    
    //TODO: Take out dice; Roll only the amount of dice corresponding to (5 - diceTakenOut) 
    // Opponent roll (should not be visible and can return Ints instead of Emoji (dices)
    // Take out dice
    
    
    //Function to reset things at the start of a new round
    func startGame() {
        for value in 0..<diceTakenOut.count {
            let currentDice = diceTakenOut[value]
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
        for value in 0..<diceTakenOut.count {
            diceTakenOut[value].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
        }
        //Reset scores
        //Call function startGame() to set up a new round
    }
    
    @IBOutlet var diceInPlay: [UIButton]!
    
    func rollDice() {
        for value in 0..<diceInPlay.count {
            let currentDice = diceInPlay[value]
            let randomValue = Int(arc4random_uniform(5))
            currentDice.setTitle(diceValues[randomValue], for: UIControlState.normal)
            
        }
        
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

