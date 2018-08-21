//
//  ClockListScene.swift
//  iScape!_SpriteKit
//
//  Created by Erica Suguimoto on 18/08/2018.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ClockListScene: SKScene {
    
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
    
    weak var myDelegate: StateChosenDelegate?
    
    var characterTextLabelNode: SKLabelNode?
    var cancelNode: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        setUpButtons()
        
        cancelNode = self.childNode(withName: "cancelNode") as? SKLabelNode
        
        // Character text
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        characterTextLabelNode?.text = "Woah it's getting late! I need to go home..."

        
        // TableView
        tableViewNode = self.childNode(withName: "tableViewNode") as? SKSpriteNode
        navBarNode = self.childNode(withName: "navBarNode") as? SKSpriteNode
        tableView.frame = CGRect(x: 0, y: 10+(navBarNode?.frame.height)!, width: (tableViewNode?.frame.width)!, height: (tableViewNode?.frame.height)!)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        self.scene?.view?.addSubview(tableView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
            case "bButton", "cancelNode":
                if let scene = ClockScene(fileNamed: "ClockScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject("InitialScene", forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    tableView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            case "startButton":
                if let scene = StartMenuScene(fileNamed: "StartMenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.clock, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    tableView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            default:
                return
            }
            
        }
        
    }
    
}

extension ClockListScene: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeZone.knownTimeZoneIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "listCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "listCell")
        }
        
        let componentsArray = TimeZone.knownTimeZoneIdentifiers[indexPath.row].components(separatedBy: "/")
        var city = componentsArray[componentsArray.count-1]
        if city.contains("_") {
            city = city.replacingOccurrences(of: "_", with: " ")
        }
        let continent = componentsArray[0]
        
        cell!.textLabel?.text = "\(city), \(continent)"
        cell!.textLabel?.textColor = .white
        cell!.textLabel?.font = UIFont(name: pixelArtFontName, size: 10)
        cell!.backgroundColor = .clear
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let componentsArray = TimeZone.knownTimeZoneIdentifiers[indexPath.row].components(separatedBy: "/")
        var city = componentsArray[componentsArray.count-1]
        if city.contains("_") {
            city = city.replacingOccurrences(of: "_", with: " ")
        }
        
        if let scene = ClockScene(fileNamed: "ClockScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            scene.userData = NSMutableDictionary()
            scene.userData?.setObject("InitialScene", forKey: "previousScene" as NSCopying)
            
            // Present the scene
            tableView.removeFromSuperview()
            self.view?.presentScene(scene)
            self.myDelegate = scene
            self.myDelegate?.stateChosenInList(stateIdentifier: TimeZone.knownTimeZoneIdentifiers[indexPath.row], city: city)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
    }
    
}

// Console View
extension ClockListScene {
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
