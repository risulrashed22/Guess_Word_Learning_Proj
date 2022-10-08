//
//  ViewController.swift
//  Guess Word
//
//  Created by Risul Rashed
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var wordsGuessed: UILabel!
    @IBOutlet weak var wordsRemaining: UILabel!
    @IBOutlet weak var wordsMissed: UILabel!
    @IBOutlet weak var wordsInTotal: UILabel!
    
    @IBOutlet weak var wordReveal: UILabel!
    @IBOutlet weak var textEnter: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var gameStut: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // Making audio file
    var audioPlayer: AVAudioPlayer!
    
    
    // Array of words to guess
    var words = ["SWIFT", "FOOT", "FAN"]
    var wordIndx = 0
    var correctWord = ""
    var guessedWord = ""
    // Variable for flower petals
    var maxPatels = 9
    var guessLeft = 9
    var wrongC = 8
    
    // Creating Audio
    func playAudio(audioName: String){
        if let sound = NSDataAsset(name: audioName){
            do{
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            }
            catch{
                print("Sound can't be played")
            }
        }
        else{
            print("Couldn't convert the sound data to 'if let'")
        }
    }
    
    // Empty Text input field
    func emptyText(){
        //textEnter.resignFirstResponder()
        textEnter.text = ""
        guessButton.isEnabled = false
    }
    func letterGuessed(){
        let userInpt = textEnter.text!
        guessedWord = guessedWord + userInpt
        var showGuessedWord = ""
        for text in correctWord{
            if guessedWord.contains(text){
                showGuessedWord = showGuessedWord + String(text)
                playAudio(audioName: "correct")
            }
            else{
                showGuessedWord = showGuessedWord + " _"
            }
        }

        //print(showGuessedWord)
        wordReveal.text = showGuessedWord
        
        // Flower Petals Drop For Wrong Guess
        if correctWord.contains(userInpt) == false && guessLeft > 0{
            guessLeft -= 1
            //imageView.image = UIImage(named: "flower\(guessLeft)")
            flowerAnimation()
            playAudio(audioName: "wrong")
        }
        
        if guessLeft == 0 {
            playAgainButton.isHidden = false
            guessLeft = maxPatels
            guessButton.isEnabled = false
            textEnter.isEnabled = false
        }
        
        if correctWord == showGuessedWord{
            textEnter.isEnabled  = false
            guessButton.isEnabled = false
            playAgainButton.isHidden = false
        }
    }
    func firstCall(){
        guessButton.isEnabled = false
        wordIndx = Int.random(in: 0...words.count-1)
        correctWord = words[wordIndx]
        print(wordIndx)
        let wordGuessing = "" + String(repeating: " _", count: words[wordIndx].count)
        wordReveal.text = wordGuessing
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstCall()
    }
    
    // UITextField
    @IBAction func keyboardDone(_ sender: UITextField) {
        letterGuessed()
        emptyText()
    }
    
    // UITextField
    @IBAction func textFieldChanges(_ sender: UITextField) {
        let inputText = textEnter.text!
        guessButton.isEnabled = !(inputText.isEmpty)
        guard inputText.isEmpty != true else{
            return
        }
        let grab = String(inputText.last!)
        //print(grab)
        sender.text = grab.uppercased()
    }
 
    @IBAction func guessClick(_ sender: Any) {
        letterGuessed()
        emptyText()
    }
    @IBAction func playAgainClick(_ sender: Any) {
        firstCall()
        textEnter.isEnabled  = true
        guessButton.isEnabled = true
        playAgainButton.isHidden = true
        guessedWord = ""
        imageView.image = UIImage(named: "flower9")
    }
    
    // Animation
    func flowerAnimation(){
        if playAgainButton.isHidden == false{
            wrongC = 8
        }
        UIView.transition(with: imageView, duration: 1, options: .transitionCrossDissolve) {
            self.imageView.image = UIImage(named: "wait\(self.wrongC)")
        } completion: { (_) in
            self.imageView.image = UIImage(named: "flower\(self.wrongC)")
            self.wrongC -= 1
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textEnter.resignFirstResponder()
    }
    

}

