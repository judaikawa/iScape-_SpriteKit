//
//  InitialScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 09/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

class InitialScene: SKScene {

    override func didMove(to view: SKView) {
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
                
            case "aButton":
                print("a")
                let transition: SKTransition = SKTransition.fade(with: UIColor.white, duration: 5)
                if let scene = MainScene(fileNamed: "MainScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene)
                }
            default:
                print("default")
                
            }
            
        }
    }
    
    
}
