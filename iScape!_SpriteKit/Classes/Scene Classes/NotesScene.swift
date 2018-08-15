//
//  NotesScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 15/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

class NotesScene: SKScene {

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
    
    // TableView
    var tableViewNode: SKSpriteNode?
    var navBarNode: SKSpriteNode?
    let tableView = UITableView()
    
    let notesTitles = ["About Me", "WWDC18"]
    let notesDetails = ["Wednesday        Hi! My name is Juliana, I'm 21 years old...", "15/03/18        I'm very excited for WWDC18! It's..."]
    let notesText = ["Hi! My name is Juliana, I'm 21 years old, I'm from Brazil and I am a undergraduate student of Statistics and a member of Apple Developer Academy, where I learned about Swift programming and started to develop my own apps.", "I'm very excited for WWDC18! It's going to be awesome!"]
    
    override func didMove(to view: SKView) {
        
        setUpButtons()
        
        // TableView
        tableViewNode = self.childNode(withName: "tableViewNode") as? SKSpriteNode
        navBarNode = self.childNode(withName: "navBarNode") as? SKSpriteNode
        tableView.frame = CGRect(x: 0, y: 10+(navBarNode?.frame.height)!, width: (tableViewNode?.frame.width)!, height: (tableViewNode?.frame.height)!)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        self.scene?.view?.addSubview(tableView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
            case "bButton":
                if let scene = MainScene(fileNamed: "MainScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    tableView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            case "startButton":
                print("startButton")
            default:
                return
            }
            
        }
        
    }
    
}

extension NotesScene: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "notesCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "notesCell")
        }
        cell?.backgroundColor = .clear
        cell?.textLabel?.text = notesTitles[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "8-bit pusab", size: 12)
        cell?.detailTextLabel?.text = notesDetails[indexPath.row]
        cell?.detailTextLabel?.font = UIFont(name: "8-bit pusab", size: 8)
        cell?.detailTextLabel?.textColor = .gray
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

// Console View
extension NotesScene {
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
