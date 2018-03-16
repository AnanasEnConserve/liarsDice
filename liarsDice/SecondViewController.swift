//
//  SecondViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 09/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var eyes = ["⚀","⚁","⚂","⚃","⚄","⚅"]
    
   // var currentroll: currentRoll?
    
    var selectedRank = false
    var swapChoices = -1
 
    @IBOutlet var rankButtons: [UIButton]!
    
    var singleSelected = false
    var selectedFirst = false
    var selectedSecond = false
    
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
        
        if selectedFirst == true && selectedSecond == true && selectedRank == true {
            submitBid.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
            submitBid.isEnabled = true
        }
    }
    
    
    @IBOutlet weak var submitBid: UIButton!
    
    
    @IBAction func buttonTouch(_ sender: Any) {
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
            //selectedRank = true
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
        

        singleSelected = false
        selectedFirst = false
        selectedSecond = false
        submitBid.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControlState.normal)
        submitBid.isEnabled = false
    }
    
    //TODO: Send message to user after trying to submit two pair with same value (did you mean: 4 of a kind??) ;; Or make this selection impossible.
    
    
    @IBOutlet var rowOne: [UIButton]!
    
    @IBOutlet var rowTwo: [UIButton]!
    
    @IBOutlet var rowThree: [UIButton]!
    
   

    @IBOutlet weak var rollDisplay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

