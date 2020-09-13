//
//  ViewController.swift
//  Word Garden
//
//  Created by Michael Ryan on 9/10/20.
//  Copyright © 2020 Michael Ryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var wordsGuessedLabel: UILabel!
    
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsInGame: UILabel!
    
    
    @IBOutlet weak var wordBeingRevealedLabel: UILabel!
    @IBOutlet weak var guessLetterTextField: UITextField!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var gameStatusMessageLabel: UILabel!
    @IBOutlet weak var flowerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessLetterTextField.text!
               guessLetterButton.isEnabled = !(text.isEmpty)
    }
    
    func updateUIAfterGuess() {
        guessLetterTextField.resignFirstResponder()
        guessLetterTextField.text! = ""
        guessLetterButton.isEnabled = false
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces)
        guessLetterButton.isEnabled = !(sender.text!.isEmpty)
        
    }
    
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        updateUIAfterGuess()
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        // This dismisses the keyboard
         updateUIAfterGuess()
        
    }
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
    }
    

}

