//
//  CalendarScene.swift
//  iScape!_SpriteKit
//
//  Created by Juliana Daikawa on 16/08/18.
//  Copyright © 2018 Juliana Daikawa. All rights reserved.
//

import SpriteKit

class CalendarScene: SKScene {

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
    
    // Current Date
    let date = Date()
    let formatter = DateFormatter()
    var weekDayString = ""
    let selectedDayLabel = UILabel()
    
    let circle = SKShapeNode(circleOfRadius: 20)
    var circleNode: SKSpriteNode?
    
    // Table View
    let cellTitleArray = ["Apps", "Fix Camera"]
    let cellDetailArray = ["Check all apps", "Must get out"]
    
    // Day of month
    var sundayDay: SKLabelNode?
    var mondayDay: SKLabelNode?
    var tuesdayDay: SKLabelNode?
    var wednesdayDay: SKLabelNode?
    var thursdayDay: SKLabelNode?
    var fridayDay: SKLabelNode?
    var saturdayDay: SKLabelNode?
    var daysOfMonthsNodes = [SKLabelNode?]()
    var dayLongNode: SKLabelNode?
    var monthNode: SKLabelNode?

    let daysOfMonths = ["sundayDay", "mondayDay", "tuesdayDay", "wednesdayDay", "thursdayDay", "fridayDay", "saturdayDay"]
    
    var characterTextLabelNode: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        passedInCalendarApp = true
        
        setUpButtons()
        
        // Character text
        characterTextLabelNode = self.childNode(withName: "grayViewNode")?.childNode(withName: "baloonNode")?.childNode(withName: "characterTextLabelNode") as? SKLabelNode
        characterTextLabelNode?.text = ""
        characterTextLabelNode?.preferredMaxLayoutWidth = 230
        SKLabelNode.animateText(label: characterTextLabelNode!, newText: "How weird... Is this a hint?!", characterDelay: characterTextDelay)
        
        // Day of month
        daysOfMonthsNodes = [sundayDay, mondayDay, tuesdayDay, wednesdayDay, thursdayDay, fridayDay, saturdayDay]
        dayLongNode = self.childNode(withName: "dayLongNode") as? SKLabelNode
        
        for i in 0..<daysOfMonthsNodes.count {
            
            daysOfMonthsNodes[i] = self.childNode(withName: daysOfMonths[i]) as? SKLabelNode
            
        }
        
        monthNode = self.childNode(withName: "monthNode") as? SKLabelNode
        monthNode?.horizontalAlignmentMode = .left
        monthNode?.position.x = (daysOfMonthsNodes[0]?.position.x)!
       
        // TableView
        tableViewNode = self.childNode(withName: "tableViewNode") as? SKSpriteNode
        navBarNode = self.childNode(withName: "navBarNode") as? SKSpriteNode
        tableView.frame = CGRect(x: 0, y: 10+(navBarNode?.frame.height)!, width: (tableViewNode?.frame.width)!, height: (tableViewNode?.frame.height)!)
        tableView.delegate = self
        tableView.dataSource = self
        self.scene?.view?.addSubview(tableView)
        
        // Current day
        let weekDay = Calendar.current.component(.weekday, from: date)
        
        // Place circle in day of week
        circleNode = self.childNode(withName: "circleNode") as? SKSpriteNode
        circle.position.x = (daysOfMonthsNodes[weekDay-1]?.position.x)!
        circle.position.y = (circleNode?.position.y)!
        daysOfMonthsNodes[weekDay-1]?.fontColor = .white
        circle.fillColor = .red
        circle.strokeColor = .red
        self.addChild(circle)
        
        // Setting days
        for i in 0..<daysOfMonthsNodes.count {
            
            daysOfMonthsNodes[i]?.text = getDayNumber(date, i-(weekDay-1))
            
        }
        
        // Setting month
        formatter.dateFormat = "MMMM"
        monthNode?.text = formatter.string(from: date)
        
        // Setting current day in long format
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        dayLongNode?.text = formatter.string(from: date)
        dayLongNode?.horizontalAlignmentMode = .center
        
    }
    
    func getDayNumber(_ date: Date, _ daysToAdd: Int) -> String {
        
        if let dateAfterAdding = Calendar.current.date(byAdding: .day, value: daysToAdd, to: date) {
            let dayNumber = Calendar.current.component(.day, from: dateAfterAdding)
            
            return "\(dayNumber)"
            
        } else {
            print("Invalid date")
            return ""
        }
    }
    
    func moveCircle(dayOfWeek: Int) {
        
        let weekDay = Calendar.current.component(.weekday, from: date)
        
        for i in 0..<daysOfMonthsNodes.count {
            if (daysOfMonthsNodes[i]?.text)! == getDayNumber(date, 0) {
                daysOfMonthsNodes[i]?.fontColor = .red
            } else {
                if i == 0 || i == 6 {
                    daysOfMonthsNodes[i]?.fontColor = .gray
                } else {
                    daysOfMonthsNodes[i]?.fontColor = .black
                }
            }
            
        }
        
        circle.position.x = (daysOfMonthsNodes[dayOfWeek-1]?.position.x)!
        daysOfMonthsNodes[dayOfWeek-1]?.fontColor = .white
        if weekDay == dayOfWeek {
            circle.fillColor = .red
            circle.strokeColor = .red
        } else {
            circle.fillColor = .black
            circle.strokeColor = .black
        }
        
        // Setting selected day
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        dayLongNode?.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: dayOfWeek-weekDay, to: date)!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            switch atPoint(location).name {
            case "sundayDay":
                moveCircle(dayOfWeek: 1)
            case "mondayDay":
                moveCircle(dayOfWeek: 2)
            case "tuesdayDay":
                moveCircle(dayOfWeek: 3)
            case "wednesdayDay":
                moveCircle(dayOfWeek: 4)
            case "thursdayDay":
                moveCircle(dayOfWeek: 5)
            case "fridayDay":
                moveCircle(dayOfWeek: 6)
            case "saturdayDay":
                moveCircle(dayOfWeek: 7)
            case "bButton":
                if let scene = MainScene(fileNamed: "MainScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.calendar, forKey: "previousScene" as NSCopying)
                    
                    // Present the scene
                    tableView.removeFromSuperview()
                    self.view?.presentScene(scene)
                }
            case "startButton":
                if let scene = StartMenuScene(fileNamed: "StartMenuScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.userData = NSMutableDictionary()
                    scene.userData?.setObject(App.calendar, forKey: "previousScene" as NSCopying)
                    
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

extension CalendarScene: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "calendarCell")
        }
        cell?.backgroundColor = .clear
        cell?.textLabel?.text = cellTitleArray[indexPath.row]
        cell?.textLabel?.font = UIFont(name: pixelArtFontName, size: 12)
        cell?.detailTextLabel?.text = cellDetailArray[indexPath.row]
        cell?.detailTextLabel?.font = UIFont(name: pixelArtFontName, size: 8)
        cell?.detailTextLabel?.textColor = .gray
        return cell!
    }
    
}

// Console View
extension CalendarScene {
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
