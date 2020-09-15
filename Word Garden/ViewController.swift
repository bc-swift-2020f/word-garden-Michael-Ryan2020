//
//  ViewController.swift
//  Word Garden
//
//  Created by Michael Ryan on 9/10/20.
//  Copyright © 2020 Michael Ryan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var wordsGuessedLabel: UILabel!
    
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    
    
    @IBOutlet weak var wordBeingRevealedLabel: UILabel!
    @IBOutlet weak var guessLetterTextField: UITextField!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var gameStatusMessageLabel: UILabel!
    @IBOutlet weak var flowerImageView: UIImageView!
    
    var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessLetterTextField.text!
               guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count - 1)
        updateGameStatusLabels()
    }
    
    func updateUIAfterGuess() {
        guessLetterTextField.resignFirstResponder()
        guessLetterTextField.text! = ""
        guessLetterButton.isEnabled = false
    }
    func formatRevealedWord () {
        // format and show revealedWord in wordBeingRevealed label to add new guess
        var revealedWord = ""
        // loop through all letters in wordToGuess
        for letter in wordToGuess {
            //check if letter in wordToGuess is in lettersGuessed (i.e. did you guess this letter already?)
            if lettersGuessed.contains(letter) {
                // if so, add this letter + a blank space, to revealedWord
                revealedWord = revealedWord + "\(letter) "
            } else {
                // if not, add an underscore + a blank space, to revealedWord
                revealedWord = revealedWord + "_ "
            }
        }
        // remove the extra space at the end of revealedWord
        revealedWord.removeLast()
        wordBeingRevealedLabel.text = revealedWord
    }
    func updateAfterWinOrLose() {
        // if game is over, increment currentWordIndex by 1. Disable guessALetterTextField. Disable guessALetterButton. Update all Labels at top of the screen
        currentWordIndex += 1
        guessLetterTextField.isEnabled = false
        guessLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        updateGameStatusLabels()
        
    }
    func updateGameStatusLabels() {
        // update labels at top of screen
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount) "
        wordsMissedLabel.text  = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = "Words to Guess: \(wordsToGuess.count - (wordsMissedCount + wordsGuessedCount))"
        wordsInGameLabel.text = "Words in Game: \(wordsToGuess.count)"
    }
    func drawFlowerAndPlaySound(currentLetterGuessed: String) {
        if wordToGuess.contains(currentLetterGuessed) == false {
            wrongGuessesRemaining = wrongGuessesRemaining - 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.flowerImageView.image = UIImage(named: "wilt\(self.wrongGuessesRemaining)")}) { (_) in
                    if self.wrongGuessesRemaining != 0 {
                        self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
                    } else {
                        self.playSound(name: "word-not-guessed")
                        UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")}, completion: nil)
                    }
                    }
                    
                    
                self.playSound(name: "incorrect")
            }
            
        } else {
            playSound(name: "correct")
        }
    }
    func guessALetter() {
        // get currentLetterGuessed and at it to all lettersGuessed
        let currentLetterGuessed = guessLetterTextField.text!
        lettersGuessed = lettersGuessed + currentLetterGuessed
        formatRevealedWord()
        
        // update image, if needed, and keep track of the wrong guesses
        drawFlowerAndPlaySound(currentLetterGuessed: currentLetterGuessed)
        // update game status message label
        guessCount += 1
//        var guesses = "Guesses"
//        if guessCount == 1 {
//            guesses = "Guess"
//        }
        let guesses = (guessCount == 1 ? "Guess" : "Guesses")
        gameStatusMessageLabel.text = "You've Made \(guessCount) \(guesses)"
        
        // check for win or lose
        if wordBeingRevealedLabel.text!.contains("_") == false {
            gameStatusMessageLabel.text = "You've guessed it! It took you \(guessCount) guesses to guess the word "
            wordsGuessedCount += 1
            playSound(name: "word-guessed")
            updateAfterWinOrLose()
        } else if wrongGuessesRemaining == 0 {
            gameStatusMessageLabel.text = "So sorry. You're out of guesses."
            wordsMissedCount += 1
            updateAfterWinOrLose()
        }
        // check to see if you've played all words
        if currentWordIndex == wordsToGuess.count {
            gameStatusMessageLabel.text! += "\n\nYou've tried all the words. Restart from the beginning?"
        }
    }
    func playSound(name:String) {
    if let sound = NSDataAsset(name: name) {
            do {
               try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {print("😡 ERROR: \(error.localizedDescription) Could Not Initialize AVAudioPlayer Object")}
            
        }else {
            print("😡 ERROR:Could Not Read Data from File sound0")
        
    }
    }
    
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
        guessLetterButton.isEnabled = !(sender.text!.isEmpty)
        
    }
    
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        // This dismisses the keyboard
         guessALetter()
        updateUIAfterGuess()
        
    }
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        // Hide play again button. Enable letterGuessed text field. Disable guess a letter button. Current word should be set to next word. set wordBeingRevealed.text to underscores separated by spaces. set wrongGuessesRemaining to maxNumberOfGuesses. set guessCount = 0. Set flower image to flower 8.
        if currentWordIndex == wordsToGuess.count {
            currentWordIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0
        }
        playAgainButton.isHidden = true
        guessLetterTextField.isEnabled = true
        guessLetterButton.isEnabled = false
        wordToGuess = wordsToGuess[currentWordIndex]
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count - 1)
        guessCount = 0
        flowerImageView.image = UIImage(named: "flower\(maxNumberOfWrongGuesses)")
        lettersGuessed = ""
        updateGameStatusLabels()
        gameStatusMessageLabel.text = "You've Made Zero Guesses"
        
    }
    

}

