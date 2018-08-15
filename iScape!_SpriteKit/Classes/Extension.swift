//
//  Extension.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 14/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

// Animate text letter by letter
extension SKLabelNode {
    
    public static func animateText(label: SKLabelNode, newText: String, characterDelay: TimeInterval, completion: @escaping (_ finish: Bool) -> Void) {
        
        var finish = false
        
        DispatchQueue.main.async {
            
            label.text = ""
            
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    label.text?.append(character)
                    if index == newText.count-1 {
                        finish = true
                        completion(finish)
                    }
                }
            }
        }
    }
    
}

extension SKSpriteNode {
    
    public static func nodeWithLabel(node: SKSpriteNode, text: String, withFontSize: CGFloat) {
        
        let label = SKLabelNode(text: text)
        label.color = UIColor.white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontName = "8-bit pusab"
        label.fontSize = withFontSize
        
        node.addChild(label)
        
    }
    
}


