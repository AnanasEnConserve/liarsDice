//
//  SecondViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 09/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var diceTakenOut: [String]!
    var playerName : String!
    var game : LiarsDiceGame!
    var delegate:SecondViewControllerDelegate! = nil
   
    var eyes = ["⚀","⚁","⚂","⚃","⚄","⚅"]
    var currentBid = [String]()
    var submittedBid = String()
    
    var currentRoll: [String] = []
    var currentRollAsString = String()
    
    var selectedRank = false
    var selectedRankValue = Int()
 
    @IBOutlet var rankButtons: [UIButton]!
    
    var singleSelected = false
    var selectedFirst = false
    var selectedSecond = false
    var singleBidValue = String()
    var doubleBidFirstValue = String()
    var doubleBidSecondValue = String()
    
    @IBAction func back(_ sender: Any) {
        delegate.comeBackFromBid(controller: self)
    }
    
    @IBAction func submitBid(_ sender: Any) {
        currentBid.removeAll()
        //0, 1, 3, 5, 6 ::  single value
        if singleSelected == true {
        var loopAmount = 3
        if selectedRankValue == 5 || selectedRankValue == 6 {
            loopAmount = selectedRankValue - 1
        }
        if selectedRankValue == 0 || selectedRankValue == 1 {
            loopAmount = selectedRankValue + 1
        }
        for _ in 0..<loopAmount {
            currentBid.append(singleBidValue)
        }
        submittedBid = currentBid.joined()
        //print(submittedBid)
        }
        
        if selectedRankValue == 2 || selectedRankValue == 4 {
            if selectedRankValue == 4 {
                currentBid.append(doubleBidFirstValue)
            }
            for _ in 0..<2 {
                currentBid.append(doubleBidFirstValue)
                currentBid.append(doubleBidSecondValue)
            }
        }
        submittedBid = currentBid.joined()
        //print(submittedBid)
        
//                print("submit")
//                guard let delegate = self.delegate else {
//                    print("Delegate not set")
//                    return
//                }
//        print("before delegate")
//        print(game)
                delegate.didSetBid(controller: self,
                                   bid: submittedBid)
    }
    //    @IBAction func submitBid(_ sender: Any) {
//        print("submit")
//        guard let delegate = self.delegate else {
//            print("Delegate not set")
//            return
//        }
//        delegate.didSetBid(controller: self,
//                           bid: "I made a bid")
//
//    }
    @IBAction func singleTouch(_ sender: Any) {
        let selectedDie = rowTwo.index(of: sender as! UIButton)
        
        if singleSelected == false {
            rowTwo[selectedDie!].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
            singleSelected = true
        }
        else {
            for index in 0..<rowTwo.count {
                if selectedDie != index {
                    rowTwo[index].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
                }
                else {
                    rowTwo[index].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
                }
            }
        }
        let selectedDieValue = rowTwo.index(of: sender as! UIButton)! + 1
        singleBidValue = String(selectedDieValue)
        if singleSelected == true && selectedRank == true {
            submitBid.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: UIControlState.normal)
            submitBid.isEnabled = true
        }
    }
    
    
    @IBAction func touchFirst(_ sender: UIButton) {
        let selectedOne = rowOne.index(of: sender)
        
        for index in 0...5{
            rowThree[index].isEnabled = true
        }
        
        
        if selectedFirst == false {
            rowOne[selectedOne!].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
            selectedFirst = true
            rowThree[selectedOne!].isEnabled = false
        }
        else {
            for index in 0...5 {
                if selectedOne != index {
                    rowOne[index].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
                }
                else {
                    rowOne[index].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
                    rowThree[index].isEnabled = false
                }
            }
        }
        doubleBidFirstValue = String(rowOne.index(of: sender)! + 1)
        
        if selectedFirst == true && selectedSecond == true && selectedRank == true {
            submitBid.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
            submitBid.isEnabled = true
        }
    }
    
    
    @IBAction func touchSecond(_ sender: UIButton) {
        let selectedTwo = rowThree.index(of: sender)

        for index in 0...5{
            rowOne[index].isEnabled = true
        }
        
        if selectedSecond == false {
            rowThree[selectedTwo!].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
            selectedSecond = true
            rowOne[selectedTwo!].isEnabled = false
        }
        else {
            for index in 0...5 {
                //rowThree[index].setTitle(eyes[index], for: UIControlState.normal)
                if index != selectedTwo {

                    rowThree[index].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
                }
                else {
                    rowThree[index].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
                    rowOne[index].isEnabled = false
                }
            }
        }
        doubleBidSecondValue = String(rowThree.index(of: sender)! + 1)
        
        if selectedFirst == true && selectedSecond == true && selectedRank == true {
            submitBid.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
            submitBid.isEnabled = true
        }
    }
    
    @IBOutlet weak var submitBid: UIButton!
    
    
    @IBAction func buttonTouch(_ sender: Any) {
        print(playerName)
        let selectedButton = rankButtons.index(of: sender as! UIButton)
        
        if selectedRank == false {
        rankButtons[selectedButton!].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
        selectedRank = true
        }
        else {
            for idx in 0..<rankButtons.count {
                if selectedButton != idx {
                rankButtons[idx].setTitleColor(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), for: UIControlState.normal)
                }
                else {
                    rankButtons[idx].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
                }
            }
        }
     
        //Adjust visibility of buttons below
        if selectedButton == 2 || selectedButton == 4 {
            for idx in 0..<rowTwo.count {
                rowTwo[idx].setTitleColor(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 0), for: UIControlState.normal)
                rowTwo[idx].isEnabled = false
                
                rowOne[idx].isEnabled = true
                rowThree[idx].isEnabled = true
                rowOne[idx].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
                rowThree[idx].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
            }
        }
        else {
            for idx in 0..<rowOne.count {
                rowOne[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
                rowThree[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
                rowOne[idx].isEnabled = false
                rowThree[idx].isEnabled = false
                
                rowTwo[idx].isEnabled = true
                rowTwo[idx].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
                
            }
        }
        
        //Set appropriate button titles (I am aware that this is awful coding)
        if selectedButton == 0 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx], for: UIControlState.normal)
            }
        }
        if selectedButton == 1 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        if selectedButton == 3 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx]+eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        if selectedButton == 5 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx]+eyes[idx]+eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        if selectedButton == 6 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx]+eyes[idx]+eyes[idx]+eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        
        //I'm sorry if your eyes start to bleed as a result of looking at this code
        if selectedButton == 2 {
            for idx in 0...5 {
                rowOne[idx].setTitle(eyes[idx]+eyes[idx], for: UIControlState.normal)
                rowThree[idx].setTitle(eyes[idx]+eyes[idx], for: UIControlState.normal)

            }
        }
        if selectedButton == 4 {
            for idx in 0...5 {
                rowOne[idx].setTitle(eyes[idx]+eyes[idx]+eyes[idx], for: UIControlState.normal)
                rowThree[idx].setTitle(eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        
        selectedRankValue = rankButtons.index(of: sender as! UIButton)!
        singleSelected = false
        selectedFirst = false
        selectedSecond = false
        submitBid.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControlState.normal)
        submitBid.isEnabled = false
    }
    
    @IBOutlet var rowOne: [UIButton]!
    
    @IBOutlet var rowTwo: [UIButton]!
    
    @IBOutlet var rowThree: [UIButton]!
    
   

    @IBOutlet weak var rollDisplay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rollDisplay.text = currentRollAsString
        //String(describing: currentRoll)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentRoll(currentRoll: [String]){
        self.currentRoll = currentRoll
       
    }
    
    func setCurrentRollAsString(currentRollAsString: String) {
         self.currentRollAsString = currentRollAsString
    }
    func setGame(game: LiarsDiceGame){
        self.game = game
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
            let mainScreen = segue.destination as! ViewController
            mainScreen.game = LiarsDiceGame(pName: playerName)
        }
        
        if segue.identifier == "submitBid" {
        let mainScreen = segue.destination as! ViewController
        mainScreen.game = LiarsDiceGame(pName: playerName)
        //mainScreen.hasLoaded = true
        //mainScreen.labelPlayer.text = playerName!
        //game.setBid(submittedBid)
        }
    }

}

protocol SecondViewControllerDelegate {
    func didSetBid(controller: SecondViewController,bid:String)
    func comeBackFromBid(controller:SecondViewController)
}
