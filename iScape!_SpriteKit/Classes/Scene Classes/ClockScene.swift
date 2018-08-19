//
//  ClockScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 15/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

class ClockScene: SKScene, StateChosenDelegate {
    
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
    
    var characterTextLabelNode: SKLabelNode?
    
    var titleNode: SKLabelNode?
    var addButtonNode: SKSpriteNode?
    
    var detailViewController: UIViewController?
    weak var timer: Timer?
    var isPointShown = true
    
    func stateChosenInList(stateIdentifier: String?, city: String?) {
        stateArray.append(city!)
        dateArray.append("")
        identifierArray.append(stateIdentifier!)
        currentStateDateString.append("")
        tableView.reloadData()
    }
    
    override func didMove(to view: SKView) {
        
        setUpButtons()
        
        titleNode = self.childNode(withName: "titleNode") as? SKLabelNode
        addButtonNode = self.childNode(withName: "addButtonNode") as? SKSpriteNode
        
        // Character text
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        
        if self.userData?.value(forKey: "previousScene") != nil {
            characterTextLabelNode?.text = "Woah it's getting late! I need to go home..."
        } else {
            characterTextLabelNode?.text = ""
            SKLabelNode.animateText(label: characterTextLabelNode!, newText: "Woah it's getting late! I need to go home...", characterDelay: characterTextDelay)
        }
        
        // Date
        setupDate()
        
        // Update Time
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupDate), userInfo: nil, repeats: true)
        
        // TableView
        tableViewNode = self.childNode(withName: "tableViewNode") as? SKSpriteNode
        navBarNode = self.childNode(withName: "navBarNode") as? SKSpriteNode
        tableView.frame = CGRect(x: 0, y: 10+(navBarNode?.frame.height)!, width: (tableViewNode?.frame.width)!, height: (tableViewNode?.frame.height)!)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        self.scene?.view?.addSubview(tableView)
        
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @objc func addTimeZone() {
        
        // Present next scene
        if let scene = ClockListScene(fileNamed: "ClockListScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            tableView.removeFromSuperview()
            self.view?.presentScene(scene)
            
        }
        
    }
    
    @objc private func setupDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        for i in 0..<stateArray.count {
            
            formatter.timeZone = TimeZone(identifier: identifierArray[i])
            currentStateDateString[i] = formatter.string(from: Date())
        }
        
        if isPointShown {
            for j in 0..<stateArray.count {
                dateArray[j] = currentStateDateString[j].replacingOccurrences(of: ":", with: " ")
            }
            isPointShown = !isPointShown
        } else {
            for j in 0..<stateArray.count {
                dateArray[j] = currentStateDateString[j].replacingOccurrences(of: " ", with: ":")
            }
            isPointShown = !isPointShown
        }
        
        
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
            case "addButtonNode":
                addTimeZone()
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

extension ClockScene: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ClockCell(style: .default, reuseIdentifier: "clockCell")
        
        cell.stateLabel.text = stateArray[indexPath.row]
        cell.timeLabel.text = dateArray[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

class ClockCell: UITableViewCell {
    
    let stateLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // State Label
        stateLabel.frame = CGRect(x: 16, y: 7.5, width: 300, height: 45)
        stateLabel.font = UIFont(name: pixelArtFontName, size: 15)
        stateLabel.textColor = .white
        contentView.addSubview(stateLabel)
        
        // Time Label
        timeLabel.frame = CGRect(x: 260, y: 10, width: 200, height: 40)
        timeLabel.font = UIFont(name: pixelArtFontName, size: 20)
        timeLabel.textColor = .white
        contentView.addSubview(timeLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol StateChosenDelegate: class {
    func stateChosenInList(stateIdentifier: String?, city: String?)
}


// Console View
extension ClockScene {
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

