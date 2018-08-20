//
//  CalculatorScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 14/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

enum ButtonType {
    case number
    case operation
}

class CalculatorScene: SKScene {
    
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
    
    // Calculator
    var resultLabelNode: SKLabelNode?
    var n1: Float?
    var n2: Float?
    var n3: Float?
    var result: Float?
    var operat: String?
    
    var characterTextLabelNode: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        passedInCalculatorApp = true
        
        resultLabelNode = self.childNode(withName: "resultLabelNode") as? SKLabelNode
        resultLabelNode?.horizontalAlignmentMode = .right
        
        setUpButtons()
        
        // Character text
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        characterTextLabelNode?.text = ""
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        SKLabelNode.animateText(label: characterTextLabelNode!, newText: "Ugh, I hate math... But go ahead if you want to", characterDelay: characterTextDelay)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            let touchedNodes = self.scene?.nodes(at: location)
            guard let nodes = touchedNodes else {
                return
            }
            
            for node in nodes {
                if let button = node as? SKButton, let name = button.name {
                    // Button from calculator
                    calculator(button: name)
                }
            }
            switch atPoint(location).name {
            case "bButton":
                if let scene = MainScene(fileNamed: "MainScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.calculator, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    self.view?.presentScene(scene)
                }
            case "startButton":
                if let scene = StartMenuScene(fileNamed: "StartMenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.calculator, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    self.view?.presentScene(scene)
                }
            default:
                return
            }
            
        }
        
    }
    
}

// Calculator Logic
extension CalculatorScene {
    
    func calculator(button: String) {
        
        if let number = Int(button) {
            numberPressed(number: number)
        } else {
            operatorPressed(operate: button)
        }
        
    }
    
    func numberPressed(number: Int) {
        if resultLabelNode?.text == "0" || resultLabelNode?.text == "Error" {
            resultLabelNode?.text = String(number)
        } else {
            if n1 == nil && operat == nil {
                if (resultLabelNode?.text?.count)! < 6 {
                    resultLabelNode?.text = (resultLabelNode?.text)! + String(number)
                }
                
            } else {
                if n3 == nil {
                    resultLabelNode?.text = String(number)
                    n3 = Float((resultLabelNode?.text)!)
                } else {
                    if (resultLabelNode?.text?.count)! < 6 {
                        resultLabelNode?.text = (resultLabelNode?.text)! + String(number)
                    }
                    
                }
            }
        }
    }
    
    func operatorPressed(operate: String) {
        n3 = nil
        if operate == "AC" {
            resultLabelNode?.text = "0"
            n1 = nil
            n2 = nil
            operat = nil
            result = nil
        } else if operate == "+-" {
            result = Float((resultLabelNode?.text)!)! * -1
            if result!.truncatingRemainder(dividingBy: Float(Int(result!))) == 0.0 {
                resultLabelNode?.text = String(Int(result!))
            } else {
                if result! == 0 {
                    resultLabelNode?.text = String(result!).replacingOccurrences(of: ".0", with: "")
                } else {
                    resultLabelNode?.text = String(result!)
                }
            }
        } else if operate == "." {
            if resultLabelNode?.text?.range(of: ".") == nil {
                n3 = 0
                if (resultLabelNode?.text?.count)! < 6 {
                    resultLabelNode?.text = (resultLabelNode?.text)! + operate
                }
                
            }
        } else if operate == "=" {
            if n1 != nil && operat != nil {
                if n2 == nil {
                    n2 = Float((resultLabelNode?.text)!)
                } else {
                    if result != nil {
                        if Float((resultLabelNode?.text)!) == result {
                            n1 = Float((resultLabelNode?.text)!)
                        } else {
                            n2 = Float((resultLabelNode?.text)!)
                        }
                    } else {
                        n2 = Float((resultLabelNode?.text)!)
                    }
                }
                switch operat! {
                case "x":
                    result = n1!*n2!
                case "/":
                    if n2 == 0 {
                        result = nil
                        n1 = nil
                        n2 = nil
                        operat = nil
                    } else {
                        result = n1!/n2!
                    }
                case "-":
                    result = n1!-n2!
                case "+":
                    result = n1!+n2!
                default:
                    print("Function not implemented")
                }
                
                if let validResult = result {
                    if validResult.truncatingRemainder(dividingBy: Float(Int(validResult))) == 0.0 {
                        resultLabelNode?.text = String(Int(validResult))
                    } else if abs(validResult) == 0 {
                        resultLabelNode?.text = String(Int(validResult))
                    } else {
                        resultLabelNode?.text = String(validResult)
                    }
                    
                } else {
                    resultLabelNode?.text = "Error"
                }
                
                
            }
            
        } else {
            if let validNumber = Float((resultLabelNode?.text)!) {
                n1 = validNumber
                operat = operate
                if operat! == "%" {
                    resultLabelNode?.text = String(n1!/100)
                }
            } else {
                n1 = nil
                n2 = nil
                operat = nil
            }
            
        }
        
    }
    
    
}


// Console View
extension CalculatorScene {
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
