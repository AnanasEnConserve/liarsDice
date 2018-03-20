//
//  StartViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 16/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {

    //var playerInfo = Player(playerName)
    var playerName = String()
    
    @IBOutlet weak var textBox: UITextField!
    
    
    @IBAction func startGame(_ sender: UIButton) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerName = textBox.text!
        textBox.resignFirstResponder()
        print(playerName)
    }
    
    
    func textFieldShouldReturn(_ textBox: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "startGame" {
        let mainScreen = segue.destination as! ViewController
        mainScreen.setPlayerName(playerName: self.playerName)
        mainScreen.labelPlayer.text = playerName
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textBox.delegate = self
        textBox.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // \(textBox.text!) needs to be passed to next view and replace the 'You' label
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


