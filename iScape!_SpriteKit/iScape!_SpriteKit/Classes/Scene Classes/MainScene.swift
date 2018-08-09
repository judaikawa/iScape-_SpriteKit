//
//  MainScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 07/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

enum Direction {
    case up
    case down
    case right
    case left
}

class MainScene: SKScene {
    
    var upButton: SKShapeNode?
    var downButton: SKShapeNode?
    var rightButton: SKShapeNode?
    var leftButton: SKShapeNode?
    var selectButton: SKShapeNode?
    var startButton: SKShapeNode?
    var aButton: SKShapeNode?
    var bButton: SKShapeNode?
    var backgroundNode: SKSpriteNode?
    var player: SKSpriteNode?
    
    // Direction Buttons
    var dirButtons = [SKShapeNode?]()
    var dirButtonsName = [String]()
    
    // Menu Buttons
    var menuButtons = [SKShapeNode?]()
    var menuButtonsName = [String]()

    override func didMove(to view: SKView) {
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
        
            switch atPoint(location).name {
            case "upButton":
                walk(dir: .up)
            case "downButton":
                walk(dir: .down)
            case "rightButton":
                walk(dir: .right)
            case "leftButton":
                walk(dir: .left)
            case "aButton":
                print("aButton")
            case "bButton":
                print("bButton")
            case "selectButton":
                print("selectButton")
            case "startButton":
                print("startButton")
            default:
                print("nothing")
            }

            
        }
        
    }
    
    func walk(dir: Direction) {
        
        guard let player = self.childNode(withName: "backgroundNode")?.childNode(withName: "player") as? SKSpriteNode else {
            return
        }
        
        switch dir {
        case .up:
            player.texture = SKTexture(image: #imageLiteral(resourceName: "walk-back1"))
        case .down:
            player.texture = SKTexture(image: #imageLiteral(resourceName: "walk-front1"))
        case .right:
            player.texture = SKTexture(image: #imageLiteral(resourceName: "walk-right1"))
        case .left:
            player.texture = SKTexture(image: #imageLiteral(resourceName: "walk-left1"))
        }
        
        
    }
    
    
}
