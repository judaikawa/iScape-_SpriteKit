//
//  PhotosScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 16/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

class PhotosScene: SKScene {
    
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
    
    // Photos
    let cameraScene = CameraScene()
    
    var collectionView = UICollectionView(frame: CGRect(x: 1, y: 100, width: 448, height: 300), collectionViewLayout: UICollectionViewFlowLayout())
    
    var collectionViewNode: SKSpriteNode?
    var navBarNode: SKSpriteNode?
    
    var characterTextLabelNode: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        passedInPhotosApp = true
        
        setUpButtons()
        
        // Character text
        var text = ""
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        characterTextLabelNode?.text = ""
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        if numberOfPictures > 0 {
            text = "We are filling the library with glitch pictures..."
        } else {
            text = "She looks like a cool girl!"
        }
        SKLabelNode.animateText(label: characterTextLabelNode!, newText: text, characterDelay: characterTextDelay)
        
        collectionViewNode = self.childNode(withName: "collectionViewNode") as? SKSpriteNode
        navBarNode = self.childNode(withName: "navBarNode") as? SKSpriteNode
        
        // COLLECTION VIEW
        let collectionFrame = CGRect(x: 0, y: (navBarNode?.frame.height)!, width: (collectionViewNode?.frame.width)!, height: (collectionViewNode?.frame.height)!)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 104.5, height: 104.5)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: "photosCell")
        self.scene?.view?.addSubview(collectionView)
        
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
                    scene.userData?.setObject(App.photos, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    collectionView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            case "startButton":
                if let scene = StartMenuScene(fileNamed: "StartMenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.photos, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    collectionView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            default:
                return
            }
            
        }
        
    }

}

extension PhotosScene: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfPictures+1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as! PhotosCell
        
        cell.backgroundColor = UIColor(red: 0.5569, green: 0.8353, blue: 0.9294, alpha: 1.0)
        
        if indexPath.row < 1 {
            cell.image.image = UIImage(named: "ju-pixel")!
        } else {
            cell.image.image = UIImage(named: "Glitch1-bw")!
        }
        
        return cell
        
    }
    
}

class PhotosCell: UICollectionViewCell {
    
    let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image.frame = CGRect(x: 0, y: 0, width: 104.5, height: 104.5)
        image.contentMode = .scaleToFill
        contentView.addSubview(image)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Console View
extension PhotosScene {
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
