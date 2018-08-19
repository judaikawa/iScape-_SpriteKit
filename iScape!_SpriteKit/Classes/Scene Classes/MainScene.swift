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

enum App {
    case mail
    case calendar
    case photos
    case notes
    case clock
    case camera
    case calculator
    case messages
}

struct PhysicsCategory {
    static let none: UInt32      = 0     // 0
    static let player: UInt32 = 0b1   // 1
    static let app: UInt32    = 0b100 // 4
}

class MainScene: SKScene, SKPhysicsContactDelegate {
    
    // Buttons
    var upButton: SKShapeNode?
    var downButton: SKShapeNode?
    var rightButton: SKShapeNode?
    var leftButton: SKShapeNode?
    var selectButton: SKShapeNode?
    var startButton: SKShapeNode?
    var aButton: SKShapeNode?
    var bButton: SKShapeNode?
    
    // Background
    var backgroundNode: SKSpriteNode?
    var blackViewNode: SKSpriteNode?
    
    // Player
    var player: SKSpriteNode?
    var playerXPosition: CGFloat = 58
    var playerYPosition: CGFloat = -50
    
    
    // Apss
    var mailApp: SKSpriteNode?
    var calendarApp: SKSpriteNode?
    var photosApp: SKSpriteNode?
    var notesApp: SKSpriteNode?
    var clockApp: SKSpriteNode?
    var cameraApp: SKSpriteNode?
    var calculatorApp: SKSpriteNode?
    var messageApp: SKSpriteNode?
    
    // Direction Buttons
    var dirButtons = [SKShapeNode?]()
    var dirButtonsName = [String]()
    
    // Menu Buttons
    var menuButtons = [SKShapeNode?]()
    var menuButtonsName = [String]()
    
    var characterTextLabelNode: SKLabelNode?
    
    // Start Menu
    var startGoToMenu = false
    let startMenuView = UIView()
    let startOptionMenuView = UIView()
    let textOptionLabel = UILabel()
    let triangleSelected = UIImageView()

    override func didMove(to view: SKView) {
        
        // Character text
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        
        characterTextLabelNode?.text = ""
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        
        // If previous scene is Initial Scene, present with actions
        blackViewNode = self.childNode(withName: "blackViewNode") as? SKSpriteNode
        if self.userData?.value(forKey: "previousScene") != nil {
            // Presenting view
            blackViewNode?.alpha = 1
            let colorize = SKAction.colorize(with: UIColor.white, colorBlendFactor: 2, duration: 2)
            let fadeOut = SKAction.fadeOut(withDuration: 2)
            blackViewNode?.run(colorize, completion: {
                self.blackViewNode?.run(fadeOut)
                SKLabelNode.animateText(label: self.characterTextLabelNode!, newText: "Wh-What is happening? A-Am I in a phone?!?", characterDelay: characterTextDelay)
            })
        } else {
            SKLabelNode.animateText(label: characterTextLabelNode!, newText: "I wonder whose phone is this...", characterDelay: characterTextDelay)
        }

        // Player position
        print(playerXPosition)
        print(playerYPosition)
        
        // Player Node
        player = self.childNode(withName: "backgroundNode")?.childNode(withName: "player") as? SKSpriteNode
        
        // Apps Node
        mailApp = self.childNode(withName: "backgroundNode")?.childNode(withName: "mailApp") as? SKSpriteNode
        calendarApp = self.childNode(withName: "backgroundNode")?.childNode(withName: "calendarApp") as? SKSpriteNode
        photosApp = self.childNode(withName: "backgroundNode")?.childNode(withName: "photosApp") as? SKSpriteNode
        notesApp = self.childNode(withName: "backgroundNode")?.childNode(withName: "notesApp") as? SKSpriteNode
        clockApp = self.childNode(withName: "backgroundNode")?.childNode(withName: "clockApp") as? SKSpriteNode
        cameraApp = self.childNode(withName: "backgroundNode")?.childNode(withName: "cameraApp") as? SKSpriteNode
        calculatorApp = self.childNode(withName: "backgroundNode")?.childNode(withName: "calculatorApp") as? SKSpriteNode
        messageApp = self.childNode(withName: "backgroundNode")?.childNode(withName: "messageApp") as? SKSpriteNode
        
        // Background Node
        backgroundNode = self.childNode(withName: "backgroundNode") as? SKSpriteNode
        
        // Physics Body
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: (backgroundNode?.frame)!)
        self.physicsWorld.contactDelegate = self
        
        // Buttons
        setUpButtons()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
            case "upButton":
                walk(dir: .up, numberOfTouches: touch.tapCount)
            case "downButton":
                walk(dir: .down, numberOfTouches: touch.tapCount)
            case "rightButton":
                walk(dir: .right, numberOfTouches: touch.tapCount)
            case "leftButton":
                walk(dir: .left, numberOfTouches: touch.tapCount)
            case "mailApp":
                walkTo(app: mailApp)
            case "calendarApp":
                walkTo(app: calendarApp)
            case "photosApp":
                walkTo(app: photosApp)
            case "notesApp":
                walkTo(app: notesApp)
            case "clockApp":
                walkTo(app: clockApp)
            case "cameraApp":
                walkTo(app: cameraApp)
            case "calculatorApp":
                walkTo(app: calculatorApp)
            case "messageApp":
                walkTo(app: messageApp)
            case "aButton":
                goToApp()
            case "bButton":
                if let scene = InitialScene(fileNamed: "InitialScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene)
                }
            case "selectButton":
                print("selectButton")
            case "startButton":
                if let scene = StartMenuScene(fileNamed: "StartMenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    self.view?.presentScene(scene)
                }
            default:
                return
            }
            
        }
        
    }
    
    func walkTo(app: SKSpriteNode?) {
        
        let pic1: UIImage?
        let pic2: UIImage?
        
        let pic3: UIImage?
        let pic4: UIImage?
        
        let diff1 = (player?.position.x)! - (app?.position.x)!
        let diff2 = (player?.position.y)! - (app?.position.y)!
        
        if (player?.position.x)! < (app?.position.x)! {
            // Player at left of app
            pic1 = #imageLiteral(resourceName: "walk-right2")
            pic2 = #imageLiteral(resourceName: "walk-right3")
        } else {
            // Player at right of app
            pic1 = #imageLiteral(resourceName: "walk-left2")
            pic2 = #imageLiteral(resourceName: "walk-left3")
        }
        
        if (player?.position.y)! < (app?.position.y)! {
            // Player at bottom of app
            pic3 = #imageLiteral(resourceName: "walk-back2")
            pic4 = #imageLiteral(resourceName: "walk-back3")
        } else {
            // Player at top of app
            pic3 = #imageLiteral(resourceName: "walk-front2")
            pic4 = #imageLiteral(resourceName: "walk-front3")
        }
        
        let x = app?.position.x
        let y = app?.position.y
        
        var duration1: TimeInterval = 1.5
        var duration2: TimeInterval = 1.5
        var count1 = 4
        var count2 = 4
        
        if diff1 < CGFloat(10) && diff1 > CGFloat(-10) {
            duration1 = 0
            count1 = 0
        }
        
        if diff2 < CGFloat(10) && diff2 > CGFloat(-10) {
            duration2 = 0
            count2 = 0
        }
        
        
        let pictureAction = SKAction.repeat(SKAction.animate(with: [SKTexture(image: pic1!), SKTexture(image: pic2!)], timePerFrame: 0.2), count: count1)
        let moveAction = SKAction.moveTo(x: x!, duration: duration1)
        player?.run(SKAction.group([pictureAction, moveAction]), completion: {
            let pictureAction = SKAction.repeat(SKAction.animate(with: [SKTexture(image: pic3!), SKTexture(image: pic4!)], timePerFrame: 0.2), count: count2)
            let moveAction = SKAction.moveTo(y: y!, duration: duration2)
            self.player?.run(SKAction.group([pictureAction, moveAction]), completion: {
                self.player?.texture = SKTexture(image: #imageLiteral(resourceName: "walk-front1"))
            })
        })

        
    }
    
    func walk(dir: Direction, numberOfTouches: Int) {
        
        switch dir {
        case .up:
            playerAction(from: #imageLiteral(resourceName: "walk-back2"), or: #imageLiteral(resourceName: "walk-back3"), to: #imageLiteral(resourceName: "walk-back1"), x: 0, y: characterStep, number: numberOfTouches)
        case .down:
            playerAction(from: #imageLiteral(resourceName: "walk-front2"), or: #imageLiteral(resourceName: "walk-front3"), to: #imageLiteral(resourceName: "walk-front1"), x: 0, y: -characterStep, number: numberOfTouches)
        case .right:
            playerAction(from: #imageLiteral(resourceName: "walk-right2"), or: #imageLiteral(resourceName: "walk-right3"), to: #imageLiteral(resourceName: "walk-right1"), x: characterStep, y: 0, number: numberOfTouches)
        case .left:
            playerAction(from: #imageLiteral(resourceName: "walk-left2"), or: #imageLiteral(resourceName: "walk-left3"), to: #imageLiteral(resourceName: "walk-left1"), x: -characterStep, y: 0, number: numberOfTouches)
        }
        
    }
    
    func playerAction(from picture: UIImage, or: UIImage, to: UIImage, x: CGFloat, y: CGFloat, number: Int) {
        
        let nextPic: UIImage?
        
        if number % 2 == 0 {
            nextPic = picture
        } else {
            nextPic = or
        }
        
        let pictureAction = SKAction.animate(with: [SKTexture(image: nextPic!), SKTexture(image: to)], timePerFrame: 0.2)
        let moveAction = SKAction.moveBy(x: x, y: y, duration: 0.5)
        player?.run(SKAction.group([pictureAction, moveAction]))
        
    }
    
    func goToApp() {
        
        playerXPosition = (player?.position.x)!
        playerYPosition = (player?.position.y)!
        
        if (player?.intersects(mailApp!))! {
            presentApp(app: .mail)
        } else if (player?.intersects(calendarApp!))! {
            presentApp(app: .calendar)
        } else if (player?.intersects(photosApp!))! {
            presentApp(app: .photos)
        } else if (player?.intersects(notesApp!))! {
            presentApp(app: .notes)
        } else if (player?.intersects(clockApp!))! {
            presentApp(app: .clock)
        } else if (player?.intersects(cameraApp!))! {
            presentApp(app: .camera)
        } else if (player?.intersects(calculatorApp!))! {
            presentApp(app: .calculator)
        } else if (player?.intersects(messageApp!))! {
            presentApp(app: .messages)
        }
        
    }
    
    func presentApp(app: App) {
        
        var appScene: SKScene?
        
        switch app {
        case .mail:
            appScene = MailScene(fileNamed: "MailScene")
        case .calendar:
            appScene = CalendarScene(fileNamed: "CalendarScene")
        case .photos:
            appScene = PhotosScene(fileNamed: "PhotosScene")
        case .camera:
            appScene = CameraScene(fileNamed: "CameraScene")
        case .clock:
            appScene = ClockScene(fileNamed: "ClockScene")
        case . notes:
            appScene = NotesScene(fileNamed: "NotesScene")
        case .calculator:
            appScene = CalculatorScene(fileNamed: "CalculatorScene")
        case .messages:
            appScene = MessagesScene(fileNamed: "MessagesScene")
        }
        
        let fadeIn = SKAction.fadeIn(withDuration: 2)
        blackViewNode?.color = UIColor.black
        blackViewNode?.run(fadeIn, completion: {
            if let scene = appScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                self.view?.presentScene(scene)
            }
        })
        
    }
    
    
}

// Console View
extension MainScene {
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


