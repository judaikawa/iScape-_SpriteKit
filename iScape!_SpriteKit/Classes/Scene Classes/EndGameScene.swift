//
//  EndGameScene.swift
//  iScape!_SpriteKit
//
//  Created by Erica Suguimoto on 19/08/2018.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit
import AVFoundation

class EndGameScene: SKScene {
    
    var playAgainNode: SKLabelNode?
    var shareNode: SKLabelNode?
    
    var bgMusicPlayer: AVAudioPlayer!

    override func didMove(to view: SKView) {
        
        resetGame()
        
        playAgainNode = self.childNode(withName: "playAgainNode") as? SKLabelNode
        
        shareNode = self.childNode(withName: "shareNode") as? SKLabelNode
        
        // Particle
        if let particleEmitter = SKEmitterNode(fileNamed: "MyParticle.sks") {
            
            particleEmitter.position = CGPoint.init(x: 0, y: (self.scene?.view?.frame.height)!/2)
            
            particleEmitter.zPosition = 2
            particleEmitter.targetNode = self
            self.addChild(particleEmitter)
            
        }
        
        // Background music
        self.playBackgroundMusic()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
            case "playAgainNode":
                let transition = SKTransition.fade(with: .black, duration: 4)
                if let scene = InitialScene(fileNamed: "InitialScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene, transition: transition)
                }
            case "shareNode":
                share()
            default:
                return
            }
            
        }
        
    }
    
    func share() {
        let vc = self.view?.window?.rootViewController
        let textToShare = "I just found an awesome game! Download iScape on the App Store!"
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        vc?.present(activityVC, animated: true, completion: nil)
    }

}

extension EndGameScene {
    
    func resetGame() {
        
        numberOfPictures = 0
        stateArray = ["Sao Paulo", "San Jose"]
        dateArray = ["", ""]
        identifierArray = ["", ""]
        currentStateDateString = ["America/Sao_Paulo","America/Los_Angeles"]
        
        passedInMailApp = false
        passedInCalendarApp = false
        passedInCalculatorApp = false
        passedInNotesApp = false
        passedInClockApp = false
        passedInCameraApp = false
        passedInPhotosApp = false
        passedInMessagesApp = false
        passedInAllApps = false
        
    }
    
}

// Background music
extension EndGameScene {
    func playBackgroundMusic() {
        if self.bgMusicPlayer == nil {
            
            let musicPath = Bundle.main.path(forResource: "end-music", ofType: "mp3")
            let musicUrl = URL(fileURLWithPath: musicPath!)
            
            self.bgMusicPlayer = try! AVAudioPlayer(contentsOf: musicUrl)
            
            self.bgMusicPlayer.numberOfLoops = -1 // tocar para sempre
            
            self.bgMusicPlayer.prepareToPlay()
        }
        
        self.bgMusicPlayer.pause()
        self.bgMusicPlayer.currentTime = 0
        self.bgMusicPlayer.play()
    }
}

