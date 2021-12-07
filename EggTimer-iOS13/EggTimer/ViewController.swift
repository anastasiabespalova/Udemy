//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var labelAbove: UILabel!
    let eggTimes = ["Soft": 3, "Medium": 420, "Hard": 720]

    var secondsPassed = 0
    var totalSeconds = 0
    var timer: Timer?
    var player: AVAudioPlayer!
    
    @IBAction func eggPressed(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        totalSeconds = eggTimes[hardness]!
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func updateCounter(){
        if secondsPassed < totalSeconds {
            let percentageProgress = Float( Float(secondsPassed) / Float(totalSeconds))
            progressBar.progress = percentageProgress
            secondsPassed += 1
        } else {
            timer?.invalidate()
            progressBar.progress = 1.0
            playSound()
            labelAbove.text = "DONE!"
        }
        
            }
    
    func playSound() {
           let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
           player = try! AVAudioPlayer(contentsOf: url!)
           player.play()
           
       }
    
}
