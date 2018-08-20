//
//  StartMenuScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 17/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit
import UIKit

class StartMenuScene: SKScene {
    
    // Buttons
    var upButton: SKShapeNode?
    var downButton: SKShapeNode?
    var rightButton: SKShapeNode?
    var leftButton: SKShapeNode?
    var selectButton: SKShapeNode?
    var startButton: SKShapeNode?
    var aButton: SKShapeNode?
    var bButton: SKShapeNode?
    
    // Direction Buttons
    var dirButtons = [SKShapeNode?]()
    var dirButtonsName = [String]()
    
    // Menu Buttons
    var menuButtons = [SKShapeNode?]()
    var menuButtonsName = [String]()
    
    var triangleNode: SKSpriteNode?
    
    // Start Menu
    var helpNode: SKLabelNode?
    var creditsNode: SKLabelNode?
    var shareGameNode: SKLabelNode?
    var optionTextNode: SKLabelNode?
    
    var appsScene = [App: SKScene?]()
    
    override func didMove(to view: SKView) {
        
        appsScene = [.mail: MailScene(fileNamed: "MailScene"), .calendar: CalendarScene(fileNamed: "CalendarScene"), .photos: PhotosScene(fileNamed: "PhotosScene"), .camera: CameraScene(fileNamed: "CameraScene"), .clock: ClockScene(fileNamed: "ClockScene"), .notes: NotesScene(fileNamed: "NotesScene"), .calculator: CalculatorScene(fileNamed: "CalculatorScene"), .messages: MessagesScene(fileNamed: "MessagesScene")]
        
        setUpButtons()
        
        triangleNode = self.childNode(withName: "triangleNode") as? SKSpriteNode
        helpNode = self.childNode(withName: "helpNode") as? SKLabelNode
        creditsNode = self.childNode(withName: "creditsNode") as? SKLabelNode
        shareGameNode = self.childNode(withName: "shareGameNode") as? SKLabelNode
        optionTextNode = self.childNode(withName: "optionTextNode") as? SKLabelNode
        optionTextNode?.alpha = 0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
            case "upButton":
                if triangleNode?.position.y != 120 {
                    triangleNode?.position.y = (triangleNode?.position.y)! + 62
                }
            case "downButton":
                if triangleNode?.position.y != -4 {
                    triangleNode?.position.y = (triangleNode?.position.y)! - 62
                }
            case "aButton":
                goToSelectedOption()
            case "bButton":
                goBackToOptions()
            case "startButton":
                
                if let previousApp = self.userData?.value(forKey: "previousScene") as? App {
                    if let scene = appsScene[previousApp]! {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        
                        // Present the scene
                        self.view?.presentScene(scene)
                    }
                } else {
                    if let scene = MainScene(fileNamed: "MainScene") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        
                        // Present the scene
                        self.view?.presentScene(scene)
                    }
                }
                
                
            default:
                return
            }
            
        }
        
    }
    
    func goToSelectedOption() {
        
        if triangleNode?.position.y != -4 {
            // Option View
            helpNode?.alpha = 0
            creditsNode?.alpha = 0
            shareGameNode?.alpha = 0
            triangleNode?.alpha = 0
            optionTextNode?.alpha = 1
            
            optionTextNode?.preferredMaxLayoutWidth = 200
            
            if triangleNode?.position.y == 120 {
                // Help
                optionTextNode?.text = "Help the character find a way out of the phone, by walking around and going inside the apps (pressing A while on top of it)."
            } else if triangleNode?.position.y == 58 {
                // Credits
                optionTextNode?.text = "Developed and designed by\nJuliana Daikawa\n\nCharacter pixel art by GugaJokes"
            }
            
        } else {
            share()
        }
        
    }
    
    func share() {
        let vc = self.view?.window?.rootViewController
        let textToShare = "I just found an awesome game! Download iScape on the App Store!"
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        vc?.present(activityVC, animated: true, completion: nil)
    }
    
    func goBackToOptions() {
        // Option View
        helpNode?.alpha = 1
        creditsNode?.alpha = 1
        shareGameNode?.alpha = 1
        triangleNode?.alpha = 1
        optionTextNode?.alpha = 0
    }

}

// Console View
extension StartMenuScene {
    func setUpButtons() {
        
        dirButtons = [upButton, downButton, rightButton, leftButton]
        dirButtonsName = ["upButton", "downButton", "rightButton", "leftButton"]
        
        menuButtons = [selectButton, startButton]
        menuButtonsName = ["selectButton", "startButton"]
        
        for i in 0..<dirButtons.count {
            roundButton(button: dirButtons[i], withName: dirButtonsName[i], cornerRadius: 5)
        }
        
        for i in 0..<menuButtons.count {
            roundButton(button: menuButtons[i], withName: menuButtonsName[i], cornerRadius: 12)
        }
    }
    
    func roundButton(button: SKShapeNode?, withName name: String, cornerRadius: CGFloat) {
        if let button = self.childNode(withName: "Console")?.childNode(withName: name) as? SKShapeNode {
            
            let roundButton = SKShapeNode(rect: button.frame, cornerRadius: cornerRadius)
            roundButton.fillColor = button.fillColor
            roundButton.strokeColor = button.strokeColor
            self.childNode(withName: "Console")?.addChild(roundButton)
            button.removeFromParent()
            roundButton.name = name
            roundButton.zPosition = 2
            
        }
    }
}

