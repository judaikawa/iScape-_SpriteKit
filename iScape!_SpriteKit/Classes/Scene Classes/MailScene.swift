//
//  MailScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 17/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

class MailScene: SKScene {
    
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
    
    let tableView = UITableView()
    
    // Mail
    let whiteView = UIView()
    let mailFrom = ["Apple Developer", "Apple"]
    let mailTitles = ["WWDC18. Don’t miss your chance to register", "Discover the new iPhone X"]
    let mailDetails = ["WWDC18. Don’t miss your chance to register.\nApple Worldwide Developers Conferece\nJune 4-8, San Jose, CA Registration closes on Thursday", "Discover the new iPhone X"]
    let messagesText = ["Hi! My name is Juliana, I'm 21 years old, I'm from Brazil and I am a undergraduate student of Statistics and a member of Apple Developer Academy, where I learned about Swift and developed my first app, MoviEye.", "I'm very excited for WWDC18! It's going to be awesome!"]
    let mailDate = ["Yesterday  >", "Monday  >"]
    let fromArray = ["Apple Developer", "Apple"]
    let toEmail = ["judaikawa@gmail.com"]
    let fromEmailLabel = UILabel()
    let emailTitleLabel = UILabel()
    
    var characterTextLabelNode: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        passedInMailApp = true
        
        setUpButtons()
        
        // Character text
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        characterTextLabelNode?.text = ""
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        SKLabelNode.animateText(label: characterTextLabelNode!, newText: "This WWDC must be really cool!", characterDelay: characterTextDelay)
        
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
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.mail, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    tableView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            case "startButton":
                if let scene = StartMenuScene(fileNamed: "StartMenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.mail, forKey: "previousScene" as NSCopying)
                    
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

extension MailScene: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = MailCell(style: .default, reuseIdentifier: "mailCell")
        
        cell.cellTitle.text = mailFrom[indexPath.row]
        cell.cellDetail.text = mailDetails[indexPath.row]
        cell.cellDetail.sizeToFit()
        cell.cellDate.text = mailDate[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        // White View for text
//        whiteView.frame = CGRect(x: 0, y: 0, width: 450, height: 400)
//        whiteView.backgroundColor = .white
//        view.addSubview(whiteView)
//
//        // Gray View
//        let grayView = UIView()
//        grayView.frame = CGRect(x: 0, y: 0, width: 450, height: 50)
//        grayView.backgroundColor = UIColor(red: 0.9725, green: 0.9725, blue: 0.9725, alpha: 1.0)
//        whiteView.addSubview(grayView)
//
//        // Line to separate
//        let lineGray = UIView()
//        lineGray.frame = CGRect(x: 0, y: 50, width: 450, height: 1)
//        lineGray.backgroundColor = .lightGray
//        whiteView.addSubview(lineGray)
//
//        // Back Button
//        let backButton = UIButton()
//        backButton.frame = CGRect(x: 5, y: 10, width: 100, height: 20)
//        backButton.setTitle("< Inbox", for: .normal)
//        backButton.setTitleColor(UIColor.blue, for: .normal)
//        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
//        backButton.titleLabel?.font = UIFont(name: pixelArtFontName, size: 12)
//        backButton.titleLabel?.textAlignment = .left
//        grayView.addSubview(backButton)
//
//        // Email info
//        let fromLabel = UILabel()
//        fromLabel.frame = CGRect(x: 15, y: 60, width: 200, height: 20)
//        fromLabel.text = "From:"
//        fromLabel.font = UIFont(name: pixelArtFontName, size: 10)
//        whiteView.addSubview(fromLabel)
//
//        fromEmailLabel.frame = CGRect(x: 85, y: 60, width: 300, height: 20)
//        fromEmailLabel.text = fromArray[indexPath.row]
//        fromEmailLabel.font = UIFont(name: pixelArtFontName, size: 10)
//        fromEmailLabel.textColor = .blue
//        whiteView.addSubview(fromEmailLabel)
//
//        let toLabel = UILabel()
//        toLabel.frame = CGRect(x: 15, y: 90, width: 100, height: 20)
//        toLabel.text = "To:"
//        toLabel.font = UIFont(name: pixelArtFontName, size: 8)
//        whiteView.addSubview(toLabel)
//
//        let toEmailLabel = UILabel()
//        toEmailLabel.frame = CGRect(x: 55, y: 90, width: 300, height: 20)
//        toEmailLabel.text = toEmail[0]
//        toEmailLabel.font = UIFont(name: pixelArtFontName, size: 8)
//        toEmailLabel.textColor = .blue
//        whiteView.addSubview(toEmailLabel)
//
//        // Line to separate
//        let line = UIView()
//        line.frame = CGRect(x: 15, y: 130, width: 450, height: 1)
//        line.backgroundColor = .gray
//        whiteView.addSubview(line)
//
//        // Title
//        emailTitleLabel.frame = CGRect(x: 15, y: 150, width: 420, height: 40)
//        emailTitleLabel.text = mailTitles[indexPath.row]
//        emailTitleLabel.font = UIFont(name: pixelArtFontName, size: 12)
//        emailTitleLabel.numberOfLines = 2
//        emailTitleLabel.sizeToFit()
//        whiteView.addSubview(emailTitleLabel)
//
//        // Email image
//        let emailImage = UIImageView()
//        emailImage.frame = CGRect(x: 15, y: 200, width: 420, height: 200)
//        emailImage.image = UIImage(named: "wwdc-email")
//        emailImage.contentMode = .scaleToFill
//        whiteView.addSubview(emailImage)
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
}

class MailCell: UITableViewCell {
    
    let cellTitle = UILabel()
    let cellDetail = UILabel()
    let cellDate = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Cell Title
        cellTitle.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width, height: 20)
        cellTitle.font = UIFont(name: pixelArtFontName, size: 10)
        contentView.addSubview(cellTitle)
        
        // Cell Detail
        cellDetail.frame = CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width, height: 30)
        cellDetail.font = UIFont(name: pixelArtFontName, size: 8)
        cellDetail.numberOfLines = 4
        cellDetail.textColor = .gray
        contentView.addSubview(cellDetail)
        
        // Date
        cellDate.frame = CGRect(x: UIScreen.main.bounds.width-110, y: 5, width: 100, height: 30)
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
extension MailScene {
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
