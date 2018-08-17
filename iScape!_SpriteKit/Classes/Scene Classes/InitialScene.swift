//
//  InitialScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 09/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

class InitialScene: SKScene {
    
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
    
    var textOnBaloonNode: SKLabelNode?
    var pressToStartNode: SKLabelNode?

    override func didMove(to view: SKView) {
        
        // Buttons
        setUpButtons()
        
        textOnBaloonNode = self.childNode(withName: "talkBaloonNode")?.childNode(withName: "textOnBaloonNode") as? SKLabelNode
        
        pressToStartNode = self.childNode(withName: "talkBaloonNode")?.childNode(withName: "pressToStartNode") as? SKLabelNode
        
        pressToStartNode?.alpha = 0
        
        textOnBaloonNode?.text = ""
        textOnBaloonNode?.numberOfLines = 3
        textOnBaloonNode?.horizontalAlignmentMode = .center
        textOnBaloonNode?.verticalAlignmentMode = .center
        SKLabelNode.animateText(label: textOnBaloonNode!, newText: "Wh... Where..\nWhere am I?!?\n   .       .       .", characterDelay: characterTextDelay) { (finished) in

            let fadeIn = SKAction.fadeIn(withDuration: 2)
            self.pressToStartNode?.run(fadeIn)
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
                
            case "aButton":
                // Go to Main Scene
                if let scene = MainScene(fileNamed: "MainScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject("InitialScene", forKey: "previousScene" as NSCopying)
                    
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
extension InitialScene {
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
