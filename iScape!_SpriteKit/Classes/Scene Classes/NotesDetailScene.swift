//
//  NotesDetailScene.swift
//  iScape!_SpriteKit
//
//  Created by Erica Suguimoto on 19/08/2018.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

class NotesDetailScene: SKScene {
    
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
    
    var notesLabel: SKLabelNode?
    var backNode: SKLabelNode?
    var characterTextLabelNode: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        setUpButtons()
        
        backNode = self.childNode(withName: "backNode") as? SKLabelNode
        notesLabel = self.childNode(withName: "notesLabel") as? SKLabelNode
        notesLabel?.preferredMaxLayoutWidth = 280
        
        if let previous = self.userData?.value(forKey: "previousScene") as? String {
            
            notesLabel?.text = previous
        }
        
        // Character text
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        characterTextLabelNode?.text = "We can get to know who this phone belongs to!"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
            case "bButton", "backNode":
                if let scene = NotesScene(fileNamed: "NotesScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject("InitialScene", forKey: "previousScene" as NSCopying)
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.notes, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    self.view?.presentScene(scene)
                }
            case "startButton":
                if let scene = StartMenuScene(fileNamed: "StartMenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.notes, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    self.view?.presentScene(scene)
                }
            default:
                return
            }
            
        }
        
    }

}

// Console View
extension NotesDetailScene {
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

