//
//  MessagesScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 14/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit
import UIKit

class MessagesScene: SKScene {
    
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
    
    var tableViewNode: SKSpriteNode?
    var navBarNode: SKSpriteNode?
    
    let messagesTitles = ["0123", "Mom"]
    let messagesDetails = ["You used 60MB of internet today.", "Ok."]
    let messagesText1 = ["You used 60MB of internet today."]
    let messagesText2 = ["Hi mom, can you pick me up at 8?", "Ok."]
    let messagesDate = ["Yesterday  >", "21/03/18  >"]
    let messagesTime = ["Yesterday, 20:41", "21/03/18, 17:56"]
    
    let tableView = UITableView()

    
    override func didMove(to view: SKView) {
        
        setUpButtons()
        
        // TableView
        tableViewNode = self.childNode(withName: "tableViewNode") as? SKSpriteNode
        navBarNode = self.childNode(withName: "navBarNode") as? SKSpriteNode
        tableView.frame = CGRect(x: 0, y: 10+(navBarNode?.frame.height)!, width: (tableViewNode?.frame.width)!, height: (tableViewNode?.frame.height)!)
        tableView.delegate = self
        tableView.dataSource = self
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

extension MessagesScene: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = MessagesCell(style: .default, reuseIdentifier: "messagesCell")
        
        cell.cellTitle.text = messagesTitles[indexPath.row]
        cell.cellDetail.text = messagesDetails[indexPath.row]
        cell.cellDate.text = messagesDate[indexPath.row]
        cell.contactImage.image = UIImage(named: "pixel-contact")
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
}

class MessagesCell: UITableViewCell {
    
    let contactImage = UIImageView()
    let cellTitle = UILabel()
    let cellDetail = UILabel()
    let cellDate = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Contact Image
        contactImage.frame = CGRect(x: 16, y: 10, width: 40, height: 40)
        contactImage.contentMode = .scaleAspectFit
        //    UIImageView.roundImage(image: contactImage, cornerRad: )
        contentView.addSubview(contactImage)
        
        // Cell Title
        cellTitle.frame = CGRect(x: 64, y: 10, width: 400, height: 20)
        cellTitle.font = UIFont(name: pixelArtFontName, size: 10)
        contentView.addSubview(cellTitle)
        
        // Cell Detail
        cellDetail.frame = CGRect(x: 64, y: 24, width: 400, height: 30)
        cellDetail.font = UIFont(name: pixelArtFontName, size: 8)
        cellDetail.textColor = .gray
        contentView.addSubview(cellDetail)
        
        // Date
        cellDate.frame = CGRect(x: 270, y: 5, width: 100, height: 30)
        cellDate.font = UIFont(name: pixelArtFontName, size: 8)
        cellDate.textColor = .gray
        cellDate.textAlignment = .right
        contentView.addSubview(cellDate)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Console View
extension MessagesScene {
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
