//
//  CameraScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 16/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit
import AVFoundation

class CameraScene: SKScene {
    
    // Camera
    let array = ["TIME-LAPSE", "SLO-MO", "VIDEO", "PHOTO", "SQUARE", "PANO"]
    var rotationAngle: CGFloat!
    var width: CGFloat = 120
    var height: CGFloat = 40
    let pickerView = UIPickerView()
    
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
    
    var cameraViewNode: SKSpriteNode?
    var lastPictureTakenNode: SKSpriteNode?
    var pickerViewNode: SKSpriteNode?
    var upperViewNode: SKSpriteNode?
    
    var characterTextLabelNode: SKLabelNode?
    
    var bgMusicPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        
        passedInCameraApp = true
        
        setUpButtons()
        
        // Character text
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        characterTextLabelNode?.text = ""
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        SKLabelNode.animateText(label: characterTextLabelNode!, newText: "Woah, this is weird... Seems like this camera is broken...", characterDelay: characterTextDelay)
        
        cameraViewNode = self.childNode(withName: "cameraViewNode") as? SKSpriteNode
        lastPictureTakenNode = self.childNode(withName: "lastPictureTakenNode") as? SKSpriteNode
        lastPictureTakenNode?.alpha = 0
        
        // Picker View Rotation
        rotationAngle = -90 * (.pi/180)
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        // Picker View
        pickerViewNode = self.childNode(withName: "pickerViewNode") as? SKSpriteNode
        upperViewNode = self.childNode(withName: "upperViewNode") as? SKSpriteNode
        pickerView.frame = CGRect(x: 0, y: (upperViewNode?.frame.height)!, width: (pickerViewNode?.frame.width)!, height: (pickerViewNode?.frame.height)!)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(3, inComponent: 0, animated: false)
        self.scene?.view?.addSubview(pickerView)
        
        // Background music
        self.playBackgroundMusic()
        
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
                    scene.userData?.setObject(App.camera, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    pickerView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            case "startButton":
                if let scene = StartMenuScene(fileNamed: "StartMenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.camera, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    pickerView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            case "cameraButton":
                numberOfPictures += 1
                
                let colorize = SKAction.colorize(with: .black, colorBlendFactor: 1, duration: 0.2)
                let colorizeLastPic = SKAction.colorize(with: .black, colorBlendFactor: 1, duration: 0.2)
                cameraViewNode?.run(colorize, completion: {
                    self.lastPictureTakenNode?.alpha = 1
                    let colorizeUndo = SKAction.colorize(withColorBlendFactor: 0, duration: 0.2)
                    self.cameraViewNode?.run(colorizeUndo)
                })
                lastPictureTakenNode?.run(colorizeLastPic, completion: {
                    let colorizeLastPicUndo = SKAction.colorize(withColorBlendFactor: 0, duration: 0.2)
                    self.lastPictureTakenNode?.run(colorizeLastPicUndo)
                })
                
            default:
                return
            }
            
        }
        
    }

}

extension CameraScene: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: height, width: width, height: 20)
        label.textAlignment = .center
        label.font = UIFont(name: pixelArtFontName, size: 10)
        label.text = array[row]
        if pickerView.selectedRow(inComponent: 0) == row {
            label.textColor = UIColor(red: 0.9804, green: 0.5882, blue: 0.0157, alpha: 1.0)
        } else {
            label.textColor = .white
        }
        view.addSubview(label)
        
        // View Rotation
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
    
}

// Background music
extension CameraScene {
    func playBackgroundMusic() {
        if self.bgMusicPlayer == nil {
            
            let musicPath = Bundle.main.path(forResource: "background-apps", ofType: "mp3")
            let musicUrl = URL(fileURLWithPath: musicPath!)
            
            self.bgMusicPlayer = try! AVAudioPlayer(contentsOf: musicUrl)
            
            self.bgMusicPlayer.numberOfLoops = -1 // tocar para sempre
            
            self.bgMusicPlayer.prepareToPlay()
        }
        
        self.bgMusicPlayer.pause()
        self.bgMusicPlayer.currentTime = 0
        self.bgMusicPlayer.play()
    }
}

// Console View
extension CameraScene {
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
