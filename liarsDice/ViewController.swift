//
//  ViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 22/02/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SecondViewControllerDelegate {

    
    
    // model that contains all data
    //
    
    var dice : Dice!
    var game : LiarsDiceGame! // = LiarsDiceGame()
    var currentRollAsString = String()
    var playerName = String()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var opponentModel : OpponentModel!
    
    var debugIndex = [Int]()
    var debugArray = [String]()
    func updateView() {
        if game.isPlayerTurn() == true {
//            //Update the dice taken out in the view
//              for i in 0..<5 {
//                if game.isFixed(i: i) {
//                debugIndex.append(i)
//                }
//            }
            
            for i in 0..<5 {
                if game.isFixed(i: i) == true && debugIndex.contains(i) == false {
                    debugArray.append(allDice[i].title(for: UIControlState.normal)!)
                    debugIndex.append(i)
                }
            }
            print("Debug Array:: " , debugArray)
            //debugArray.sort()
            for index in 0..<debugArray.count {
                diceTakenOut[index].setTitle(debugArray[index], for: UIControlState.normal)
            }
            //Reset debugArray as it will be set again on the next turn
            //debugArray.removeAll()
            
            
            bluffButton.isHidden = true
            acceptButton.isHidden = true
            
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
            //Set game up for players turn
            rollButton.isEnabled = true
            rollButton.isHidden = false
            
            //show AllDice
            for index in 0..<5 {
               if(game.isInPlay(i: index)){
                    allDice[index].isEnabled = true
                    allDice[index].isHidden = false
                }
            }
            resetButton.isEnabled = true
            resetButton.isHidden = false
            holdButton.isHidden = false
            holdButton.isEnabled = true
            opponentBid.isHidden = true
            
        }
        if game.isOpponentTurn() == true {
            bidButton.isHidden = true
            bidButton.isEnabled = false
            
            print("It is now the Opponent's turn")
            opponentBid.text = "Dumb AI is considering his options..."
            opponentBid.isHidden = false
            
            //hide AllDice
            for index in 0..<5 {
                allDice[index].isEnabled = false
                allDice[index].isHidden = true
            }
            
            //Disable all buttons /NOTE:(bidButton is being handled elsewhere)
            resetButton.isEnabled = false
            resetButton.isHidden = true
            holdButton.isHidden = true
            holdButton.isEnabled = false
            
            //Show the activity indicator
            activityIndicator.startAnimating()
            //Stop this when the opponent has made a bid!
            //if opponentdidsetbid = true, call seperate function
            //There, display the bid on the appropriate label
    
            print("before calculate turn")
            print(game.getLastBid())
            if (opponentModel.calculateTurn()){
            let didPlayerWin = !game.callBluff() // falsely called bluff = player wins win
                if didPlayerWin{
                    print("Player won")
                    roundResult.text = "YOU WON!!!!!! PRESS CONTINUE TO... WELL CONTINUE OBVIOUSLY"
                    roundResult.isHidden = false
                    continueButton.isEnabled = true
                    continueButton.isHidden = false
                }
                else{
                    print("Opponent won")
                    roundResult.text = "You lost. Too bad"
                    roundResult.isHidden = false
                    continueButton.isEnabled = true
                    continueButton.isHidden = false
                }
                self.updateScores()
                game.reset()
                self.highlightTurn()
                rollButton.isEnabled = false
                rollButton.isHidden = true
                return
            }
            
            print("after calculate turn")
            print(game.getLastBid())
            activityIndicator.stopAnimating()
            self.opponentHasBid()
            self.highlightTurn()
            
            for i in 0..<5 {
                if game.isFixed(i: i) == true && debugIndex.contains(i) == false {
                    debugArray.append(allDice[i].title(for: UIControlState.normal)!)
                    debugIndex.append(i)
                }
            }
            for i in 0..<5 {
                if !game.isFixed(i: i) {
                    let j = game.getDiceNumber(i)
                    allDice[i].setTitle(diceValues[j-1], for: UIControlState.normal)
                }
            }
            print("Debug Array:: " , debugArray)
            //debugArray.sort()
            for index in 0..<debugArray.count {
                diceTakenOut[index].setTitle(debugArray[index], for: UIControlState.normal)
            }
        }
    }
    
    @IBAction func acceptBid(_ sender: Any) {
        print("I am accepting the bid")
        if(game.isBidABluff()){
            opponentModel.incrementPlayerGul()
        }
        self.updateView()
    }
    
    func opponentHasBid() {
        var displayOpponentBid = [String]()
        var tempOpponentBid = game.getLastBid()
        
        while tempOpponentBid.length != 0 {
            displayOpponentBid.append(tempOpponentBid[0])
            tempOpponentBid.remove(at: tempOpponentBid.startIndex)
        }
        
        for idx in 0..<displayOpponentBid.count {
            let integer = Int(displayOpponentBid[idx])
            displayOpponentBid[idx] = diceValues[integer! - 1]
        }
        let joinedOpponentBid = displayOpponentBid.joined(separator: " ")
        
        //Set the label to display the bid for the opponent
        opponentBid.text = "Opponent has bid: " + joinedOpponentBid
        showBid.text = "Current Bid: " + joinedOpponentBid
        opponentBid.isHidden =  false
        
        displayOpponentBid.removeAll()
        
        //Enable && display the accept/bluff buttons
        acceptButton.isHidden = false
        acceptButton.isEnabled = true
        bluffButton.isHidden = false
        bluffButton.isEnabled = true
    }
    
    
    
    let elements = ["High card", "One pair", "Two pair", "Three of a kind", "Full house", "Four of a kind", "Five of a kind"]
    
    
    
    @IBOutlet weak var holdButton: UIButton!
    
    @IBOutlet weak var bidButton: UIButton!
    @IBAction func Bid(_ sender: UIButton) {
//        bidButton.isHidden = true
//        bidButton.isEnabled = false
    }
  
    //Declare array of values the dice can take
    var diceValues = ["⚀","⚁","⚂","⚃","⚄","⚅"]

    @IBOutlet weak var labelOpponent: UILabel!
    @IBOutlet weak var labelPlayer: UILabel!
    @IBOutlet weak var labelOpponentScore: UILabel!
    @IBOutlet weak var labelOpponentStreak: UILabel!
    @IBOutlet weak var labelPlayerScore: UILabel!
    @IBOutlet weak var labelPlayerStreak: UILabel!
    
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var opponentBid: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var bluffButton: UIButton!
    
    let colorNormal = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let colorHighlighted = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    
    var removedDice = [String]()
    // The dice buttons displayed on the side, representing the fixed ones
    @IBOutlet var diceTakenOut: [UIButton]!
    // ALL Dice, including the ones taken out. The ones that are taken out are simply set to "hidden" but they are still there
    @IBOutlet var allDice: [UIButton]!
    
    //Array to store all strings as rolled in the current turn
    var currentRoll = [" "," "," "," "," "]
    
    @IBAction func rollDice(_ sender: UIButton) {
        rollDice()
        rollButton.isHidden = true
        rollButton.isEnabled = false
        bidButton.isHidden = false
        bidButton.isEnabled = true
        holdButton.isHidden = true
        holdButton.isEnabled = false
    }
    
    //TODO:
    // Only show the 'Hold' button when appropriate (disable it otherwise and possibly hide it/set opacity to 0%)
    // Create animation or something to indicate to the player that the opponent is rolling**
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
                allDice[selectedDice].setTitleColor(colorHighlighted, for: UIControlState.normal)
            }
            else {
                while selected[getIndex] != selectedDice {
                    getIndex += 1
                }
                selected.remove(at: getIndex)
                allDice[selectedDice].setTitleColor(colorNormal, for: UIControlState.normal)
            }
        }
            print(selected)
    }
    
    //Function to reset things at the start of a new round
    func startGame() {
       // if game.isPlayerTurn() == true {
        
        for idx in 0..<5 {
            if idx < 4 {
            diceTakenOut[idx].setTitle(" ", for: UIControlState.normal)
            allDice[idx].isEnabled = false
            allDice[idx].setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControlState.normal)
            }
            else {
                allDice[idx].isEnabled = false
                allDice[idx].setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControlState.normal)
            }
        }
        showBid.text = " "
        
            bluffButton.isHidden = true
            acceptButton.isHidden = true
            
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
            //Set game up for players turn
            rollButton.isEnabled = true
            rollButton.isHidden = false
            
            //show AllDice
            for index in 0..<5 {
                if  index < 4 {
                    diceTakenOut[index].setTitle("", for: UIControlState.normal)
                    allDice[index].setTitle("", for: UIControlState.normal)
                    //allDice[index].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
                    allDice[index].isEnabled = false
                    allDice[index].isHidden = false
                }
                else {
                   // allDice[index].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
                    allDice[index].setTitle("", for: UIControlState.normal)
                    allDice[index].isEnabled = false
                    allDice[index].isHidden = false
                }
            }
            resetButton.isEnabled = true
            resetButton.isHidden = false
            holdButton.isHidden = true
            holdButton.isEnabled = false
            opponentBid.isHidden = true
            rollButton.isEnabled = true
           rollButton.isHidden = false
        
        
        
        }
        //        game.reset()
//        removed.removeAll()
//        selected.removeAll()
//        highlightTurn()
//        for value in 0..<diceTakenOut.count {
//            let currentDice = diceTakenOut[value]
//            currentDice.setTitle(" ", for: UIControlState.normal)
//            currentDice.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
//        }
   // }
    
    @IBOutlet weak var roundResult: UILabel!
    
    
    //Array to keep track of which and how many buttons are already taken out
    var removed = [Int]()
    
    
    //Function to transfer dice from InPlay to TakenOut
    @IBAction func removeDice(_ sender: UIButton) {
        
        print("Current roll for cheaters (REMOVEDICE): ")
        print(game.getRoll())
        if removed.count + selected.count == 5 {
            print("I'm afraid I can't let you do that Dave")
            return
        }
        // fix dice in the model
        game.fixDice(selected)
        //dice.fix()
        // make the dice disappear in the UI
        for buttonIndex in selected{
            allDice[buttonIndex].isHidden = true
        }
        // todo: is this needed? Also add sanity check?
        removed.append(contentsOf: selected)
    
        
        // make them appear in the fixed row
        for index in 0..<5 {
            if game.isFixed(i: index) == true && debugIndex.contains(index) == false {
            debugArray.append(allDice[index].title(for: UIControlState.normal)!)
                debugIndex.append(index)
            }
        }
        //debugArray.sort()
        for index in 0..<debugArray.count {
            diceTakenOut[index].setTitle(debugArray[index], for: UIControlState.normal)
        }
        
//        for i in 0..<selected.count {
//                diceTakenOut[removed.count - selected.count + i + debugArray.count].setTitle(currentRoll[selected[i]], for: UIControlState.normal)
//                //debugArray.append(currentRoll[selected[i]])
//        }
        
        //debugArray.removeAll()
        // clear selection
        selected.removeAll()
        

    }
      //TODO: Only allow to Hold once per turn;
    
    func highlightTurn() {
        if game.isPlayerTurn(){
            labelPlayer.textColor = colorHighlighted
            labelOpponent.textColor = colorNormal
        } else {
            labelPlayer.textColor = colorNormal
            labelOpponent.textColor = colorHighlighted
        }
    }
    
    func updateScores(){
        labelPlayerScore.text = "Score: " + String(game.getPlayer().getScore())
        labelPlayerStreak.text = "Streak: " + String(game.getPlayer().getStreak())
        labelOpponentScore.text = "Score: " + String(game.getOpponent().getScore())
        labelOpponentStreak.text = "Streak: " + String(game.getOpponent().getStreak())
        startGame()
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        reset()
    }
    
    //Function to reset the game (start new round && reset scores)
    func reset() {
        game.reset()
        removed.removeAll()
        selected.removeAll()
        labelPlayerScore.text = "Score: 0"
        labelOpponentScore.text = "Score: 0"
        for i in 0..<5{
            allDice[i].isEnabled = false
            allDice[i].setTitle(" ", for: UIControlState.normal)
            allDice[i].setTitleColor(colorNormal, for: UIControlState.normal)
        }
        highlightTurn()
        showBid.text = " "
        holdButton.isHidden = true
        holdButton.isEnabled = false
        bidButton.isHidden = true
        bidButton.isEnabled = false
        //Revert colors && enable buttons for dice
//        for index in 0..<allDice.count {
//            allDice[index].setTitleColor(colorNormal, for: UIControlState.normal)
//            allDice[index].isEnabled = true
//            allDice[index].isHidden = false
//        }
        
        for value in 0..<diceTakenOut.count {
            diceTakenOut[value].setTitle(" ", for: UIControlState.normal)
            //diceTakenOut[value].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
        }
        
        //TODO: Reset scores
        //Call function startGame() to set up a new round?
    }
    
   
    func rollDice() {
        
        game.rollDice()
        for j in 0..<5{
            self.allDice[j].setTitle(" ", for: UIControlState.normal)
        }
        for i in 0..<6{
             DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)*0.1) {
                if(i < 5){
                    for j in 0..<5{
                        self.allDice[j].setTitle(self.diceValues[Int(arc4random_uniform(6))], for: UIControlState.normal)
                    }
                    
                }
                else{
                    for j in 0..<5 {
                        let value = self.game.getDiceNumber(j)
                        self.allDice[j].setTitle(self.diceValues[value-1], for: UIControlState.normal)
                        self.currentRoll[j] = self.diceValues[value-1]
                    }
                }
             }
        }
        for i in 0..<5 {
            let value = game.getDiceNumber(i)
            print("value:: " , value)
            allDice[i].setTitle(diceValues[value-1], for: UIControlState.normal)
            currentRoll[i] = diceValues[value-1]
        }
        print("currentroll:: " , currentRoll)
        currentRollAsString = currentRoll.joined(separator: " ")
        print(currentRollAsString)
       // print("Array of Current Roll: ", currentRoll)
    }
    
    //Work in progress to get the current dice values to display when bidding
        func presentDestinationViewController() {
            let currentroll = currentRoll
            let destinationViewController = SecondViewController(nibName: "SecondViewController", bundle: nil)
            destinationViewController.rollDisplay.text = currentroll.joined(separator: " ")
           // present(destinationViewController, animated: false, completion: nil)
        }
    
    func setPlayerName(playerName: String) {
        self.playerName = playerName
    }
    
    
    //Segue to transfer player name to main view controller (AND model)
    //This does NOT work as of yet, needs attention
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // let currentroll = currentRoll
        if segue.identifier == "goToBidding"{
            let biddingScreen = segue.destination as! SecondViewController
            biddingScreen.setCurrentRoll(currentRoll: self.currentRoll)
            biddingScreen.setCurrentRollAsString(currentRollAsString: currentRollAsString)
            biddingScreen.setGame(game: game)
            biddingScreen.delegate = self
            
            biddingScreen.playerName = labelPlayer.text
//
//            for index in 0..<allDice.count {
//                if allDice[index].isHidden == true {
//                    removedDice.append(allDice[index].currentTitle!)
//                }
//
//            }
            
        }
//        if let SecondViewController = segue.destination as? SecondViewController {
//            SecondViewController.currentroll = currentroll
//        }
    }
    
    
    @IBAction func setupNextRound(_ sender: UIButton) {
        startGame()
        for i in 1..<5{
            allDice[i].setTitleColor(colorNormal, for: UIControlState.normal)
        }
        roundResult.isHidden = true
        continueButton.isHidden = true
        continueButton.isEnabled = false
    }
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var showBid: UILabel!
    
    @IBAction func callBluff(_ sender: Any) {
        let didPlayerWin = game.callBluff()
        
        if(game.isBidABluff()){
            opponentModel.decrementPlayerGul()
        } else{
            // this is a bit of a tricky case: the model didn't bluff but the player thought so
            // our modeller decided that being wrong counts towards being gullible
            opponentModel.incrementPlayerGul()
        }
        print("updating")
        opponentModel.updatePlayerProfile()
        
        if didPlayerWin{
            print("Player won")
            roundResult.text = "YOU WON!!!!!! PRESS CONTINUE TO... WELL CONTINUE OBVIOUSLY"
            roundResult.isHidden = false
            continueButton.isEnabled = true
            continueButton.isHidden = false
            rollButton.isHidden = true
        }
        else{
            print("Opponent won")
            roundResult.text = "You lost. Too bad"
            roundResult.isHidden = false
            continueButton.isEnabled = true
            continueButton.isHidden = false
            rollButton.isHidden = true
        }
        self.updateScores()
        //game.reset()
        self.highlightTurn()
    }
    
    var tempBid = String()
    var displayBid = [String]()
    func didSetBid(controller: SecondViewController, bid: String) {
        print("I am the MainViewController and I have received the bid: " + bid)
        
        
        tempBid = bid
        while tempBid.length != 0 {
            displayBid.append(tempBid[0])
            tempBid.remove(at: tempBid.startIndex)
        }
        print("DisplayBid::  ",displayBid)
        
        for idx in 0..<displayBid.count {
            let somethingAwesome = Int(displayBid[idx])
            displayBid[idx] = diceValues[somethingAwesome! - 1]
        }
        displayBid.sort()
        print("ConvertedBid:: ",displayBid)
        let convertedBid = displayBid.joined(separator: " ")

        showBid.text = "Current Bid: " + convertedBid
        game.setBid(bid)
        
        displayBid.removeAll()
        
        // after the bid, its the oppponents turn
        _ = game.toggleTurn()
        self.highlightTurn()
        self.updateView()
    controller.navigationController?.popViewController(animated: true)
    }
    func comeBackFromBid(controller: SecondViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
    var hasLoaded = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //labelPlayer.text = playerName
        print(game)
       // if hasLoaded == false {
        labelPlayer.text = game.getPlayer().getName()
        labelOpponent.text = game.getOpponent().getName()
            hasLoaded = true
       // }
        //updateView()
        // Do any additional setup after loading the view, typically from a nib.
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


