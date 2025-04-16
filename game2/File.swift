//
//  File.swift
//  game2
//
//  Created by Riley Shinnick on 4/19/24.
// 

import Foundation
import SpriteKit
import CoreMotion


class Game: SKScene, SKPhysicsContactDelegate {
    
    var character: SKSpriteNode!
    var things: [SKSpriteNode] = []
    
    var thingColorIndexes: [String: Int] = [:]
    var thingHitCounts: [String: Int] = [:] // Track the number of hits for each thing
    
    var sound: SKAction!
    
    var restartButton:SKLabelNode?
    
    var countLabel: SKLabelNode?
    
    let rainbowColors: [UIColor] = [
        UIColor(red: 204.0 / 255.0, green: 161.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0), // purple
        UIColor(red: 255.0 / 255.0, green: 211.0 / 255.0, blue: 211.0 / 255.0, alpha: 1.0), // pink
        UIColor(red: 243.0 / 255.0, green: 160.0 / 255.0, blue: 173.0 / 255.0, alpha: 1.0), // red
        UIColor(red: 190.0 / 255.0, green: 209.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0), // yellow
        UIColor(red: 146.0 / 255.0, green: 161.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)  //
    ]
    
    var motion = CMMotionManager()
    
    var isIdle = true
    
    var menuButton: SKLabelNode?
    var instructionsLabel: SKLabelNode?
    var instructionsText: SKLabelNode?
    var instructionsThing: SKLabelNode?
    
    var xButton: SKLabelNode?
        
    override func didMove(to view: SKView) {
        motion.startDeviceMotionUpdates()
        
        backgroundColor = UIColor(red: 249.0 / 255.0, green: 249.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
        
        physicsWorld.contactDelegate = self
        
        if let path = Bundle.main.path(forResource: "thump-87726", ofType: "mp3") {
            print("Bundle path:", path)
            let url = URL(fileURLWithPath: path)
            sound = SKAction.playSoundFileNamed(url.lastPathComponent, waitForCompletion: false)
        } else {
            print("Sound file not found")
        }
        
        // Add counter label
        countLabel = SKLabelNode(text: "0")
        countLabel?.fontSize = 50
        countLabel?.fontColor = .gray
        countLabel?.fontName = "San-Francisco"
        countLabel?.position = CGPoint(x: frame.midX + 150, y: frame.maxY - 90)
        addChild(countLabel!)
        
        //add boundary walls
        wall(point: CGPoint(x: frame.midX, y: 0), size: CGSize(width: frame.width, height: 0.5))
        wall(point: CGPoint(x: frame.midX, y: frame.height - 130), size: CGSize(width: frame.width, height: 1))
        wall(point: CGPoint(x: 5, y: frame.midY), size: CGSize(width: 0.5, height: frame.height))
        wall(point: CGPoint(x: frame.width - 5, y: frame.midY), size: CGSize(width: 1, height: frame.height))
        
        
        makeCharacter()
        makeThing1()
        makeThing2()
        makeThing3()
        makeThing4()
        
        menuButton = SKLabelNode(text: "\u{2261}")
        menuButton?.fontSize = 70
        menuButton?.fontName = "Helvetica-Bold"
        menuButton?.fontColor = .gray
        menuButton?.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 80)
        menuButton?.name = "menuButton"
        addChild(menuButton!)
        
    }
    
    func makeCharacter() {

        let characterSize = CGSize(width: 35, height: 35)
        let position = CGPoint(x: frame.midX - 50, y: frame.midY)
        
        character = SKSpriteNode(color: .gray, size: characterSize)
        
        let body = SKPhysicsBody(rectangleOf: characterSize)
        character.position = position
        body.affectedByGravity = true
        body.allowsRotation = false
        body.linearDamping = 0.5
        body.angularDamping = 1.2
        body.categoryBitMask = 0x1 << 0 // Set category bit mask
        body.contactTestBitMask = 0x1 << 1 // Set contact test bit mask for detecting collisions with 'thing'
        character.physicsBody = body
        addChild(character)
        
        character.physicsBody?.velocity = CGVector(dx: 600, dy: 600)
        character.physicsBody?.restitution = 1.2
    }
    
    
    func makeThing1() {
        let thingSize = CGSize(width: 40, height: 40)
        let positions: [CGPoint] = [CGPoint(x: frame.midX - 100, y: frame.midY)]
            
        // Initialize currentColorIndex to 0
        var currentColorIndex = 0
            
        for position in positions {
            currentColorIndex = 0
                
            let thing = SKSpriteNode(color: rainbowColors[currentColorIndex], size: thingSize)
            thing.position = position
            thing.name = "thing\(things.count)"
            things.append(thing)
            addChild(thing)
                
            let body = SKPhysicsBody(rectangleOf: thingSize)
            body.affectedByGravity = true
            body.categoryBitMask = 0x1 << 1 // Set category bit mask
            body.contactTestBitMask = 0x1 << 0 // Set contact test bit mask for detecting collisions with 'robot'
            thing.physicsBody = body
                
            body.linearDamping = 0.1
            body.angularDamping = 0.5
            
            // Increment currentColorIndex and ensure it loops back to 0 when it exceeds rainbowColors count
            currentColorIndex += 1
            currentColorIndex %= rainbowColors.count
            
            // Store the currentColorIndex for this thing in the thingColorIndexes dictionary
            thingColorIndexes[thing.name!] = (currentColorIndex - 1 + rainbowColors.count) % rainbowColors.count
        }
    }
    
    func makeThing2() {
        let thingSize = CGSize(width: 30, height: 30)
        let positions: [CGPoint] = [CGPoint(x: frame.midX, y: frame.midY + 100)]
            
        var currentColorIndex = 0
            
        for position in positions {
            currentColorIndex = 0
                
            let thing = SKSpriteNode(color: rainbowColors[currentColorIndex], size: thingSize)
            thing.position = position
            thing.name = "thing\(things.count)"
            things.append(thing)
            addChild(thing)
                
            let body = SKPhysicsBody(rectangleOf: thingSize)
            body.affectedByGravity = true
            body.categoryBitMask = 0x1 << 1 // Set category bit mask
            body.contactTestBitMask = 0x1 << 0 // Set contact test bit mask for detecting collisions with 'robot'
            thing.physicsBody = body
            
            thing.physicsBody?.velocity = CGVector(dx: 300, dy: 300)
            
            // Increment currentColorIndex and ensure it loops back to 0 when it exceeds rainbowColors count
            currentColorIndex += 1
            currentColorIndex %= rainbowColors.count
            
            // Store the currentColorIndex for this thing in the thingColorIndexes dictionary
            thingColorIndexes[thing.name!] = (currentColorIndex - 1 + rainbowColors.count) % rainbowColors.count
        }
    }
    
    func makeThing3() {
        let thingSize = CGSize(width: 60, height: 60)
        let positions: [CGPoint] = [CGPoint(x: frame.midX, y: frame.midY - 100)]
            
        var currentColorIndex = 0
            
        for position in positions {
            currentColorIndex = 0
            
            let thing = SKSpriteNode(color: rainbowColors[currentColorIndex], size: thingSize)
            thing.position = position
            thing.name = "thing\(things.count)"
            things.append(thing)
            addChild(thing)
                
            let body = SKPhysicsBody(rectangleOf: thingSize)
            body.affectedByGravity = true
            body.categoryBitMask = 0x1 << 1 // Set category bit mask
            body.contactTestBitMask = 0x1 << 0 // Set contact test bit mask for detecting collisions with 'robot'
            thing.physicsBody = body
                
            thing.physicsBody?.velocity = CGVector(dx: 500, dy: 500)
            
            // Increment currentColorIndex and ensure it loops back to 0 when it exceeds rainbowColors count
            currentColorIndex += 1
            currentColorIndex %= rainbowColors.count
            
            
            // Store the currentColorIndex for this thing in the thingColorIndexes dictionary
            thingColorIndexes[thing.name!] = (currentColorIndex - 1 + rainbowColors.count) % rainbowColors.count
        }
    }
    
    func makeThing4() {
        let thingSize = CGSize(width: 50, height: 50)
        let positions: [CGPoint] = [CGPoint(x: frame.midX + 100, y: frame.midY)]
            
        var currentColorIndex = 0
            
        for position in positions {
            currentColorIndex = 0
            
            let thing = SKSpriteNode(color: rainbowColors[currentColorIndex], size: thingSize)
            thing.position = position
            thing.name = "thing\(things.count)"
            things.append(thing)
            addChild(thing)
                
            let body = SKPhysicsBody(rectangleOf: thingSize)
            body.affectedByGravity = true
            body.categoryBitMask = 0x1 << 1 // Set category bit mask
            body.contactTestBitMask = 0x1 << 0 // Set contact test bit mask for detecting collisions with 'robot'
            thing.physicsBody = body
                
            thing.physicsBody?.velocity = CGVector(dx: 500, dy: 500)
            
            // Increment currentColorIndex and ensure it loops back to 0 when it exceeds rainbowColors count
            currentColorIndex += 1
            currentColorIndex %= rainbowColors.count
            
            // Store the currentColorIndex for this thing in the thingColorIndexes dictionary
            thingColorIndexes[thing.name!] = (currentColorIndex - 1 + rainbowColors.count) % rainbowColors.count
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Check if the collision is between robot and thing
        if collision == 0x1 << 0 | 0x1 << 1 {
            
            self.run(sound)
            
            // Determine which node is the 'thing'
            let thingNode: SKSpriteNode?
            if contact.bodyA.categoryBitMask == 0x1 << 1 {
                thingNode = contact.bodyA.node as? SKSpriteNode
            } else {
                thingNode = contact.bodyB.node as? SKSpriteNode
            }
            
            // Ensure the thing node exists
            guard let node = thingNode, let thingName = node.name else { return }
            
            // Change the color of the thing
            let colorIndex = thingColorIndexes[thingName] ?? 0
            node.color = rainbowColor(index: colorIndex)
            
            // Increment color index for the thing
            thingColorIndexes[thingName] = (colorIndex + 1) % rainbowColors.count
            
            // Increment hit count for the thing
            thingHitCounts[thingName, default: 0] += 1
            
            // Check if all things have been hit at least once
            let allThingsHit = thingHitCounts.count == 4 && thingHitCounts.values.allSatisfy { $0 > 0 }
            
            if allThingsHit {
                // Increment the counter only after all things have been hit
                let sameColorCount = things.filter { $0.color == node.color }.count
                countLabel?.text = "\(sameColorCount)"
            }
                    
            // Check if all things have the same color
            let sameColor = things.allSatisfy { $0.color == things[0].color }
                    
            // If all things have the same color and have been hit, trigger game over
            if sameColor && things.allSatisfy({ thingHitCounts[$0.name!] ?? 0 > 1 }) {
                gameOver()
            }
        }
    }
    
    func rainbowColor(index: Int) -> UIColor {
        return rainbowColors[index % rainbowColors.count]
    }
    
    func wall(point: CGPoint, size: CGSize) {
        let wall = SKSpriteNode(color: .clear, size: size)
        wall.position = point
        let body = SKPhysicsBody(rectangleOf: wall.size)
        body.isDynamic = false
        wall.physicsBody = body
        addChild(wall)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let deviceMotion = motion.deviceMotion {
            let gravity = deviceMotion.gravity
            let magnitude = 2.0
            physicsWorld.gravity = CGVector(dx: gravity.x * magnitude, dy: gravity.y * magnitude)
        }
    }
    
    func gameOver() {
        let background = SKShapeNode(rectOf: CGSize(width: 300, height: 200), cornerRadius: 10)
            background.fillColor = SKColor.black.withAlphaComponent(0.5) // Adjust opacity as needed
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(background)
        
        let gameOverLabel = SKLabelNode(text: "You Won!")
        gameOverLabel.fontName = "Helvetica-Bold"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 10)
        addChild(gameOverLabel)
        
        restartButton = SKLabelNode(text: "Restart")
        restartButton?.fontSize = 20
        restartButton?.fontName = "Helvetica-Bold"
        restartButton?.fontColor = .white
        restartButton?.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        restartButton?.name = "restartButton"
        addChild(restartButton!)
            
        isPaused = true
    }
    
    override func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // Check if the restart button is touched
            if let node = self.atPoint(location) as? SKLabelNode, node.name == "restartButton" {
                restartGame()
                return
            }
            
            // Check if the menu button is touched
            if let node = self.atPoint(location) as? SKLabelNode, node.name == "menuButton" {
                isPaused = true
                
                instructionsLabel = SKLabelNode(text: "Rotate device to move squares.")
                instructionsLabel?.fontSize = 25
                instructionsLabel?.fontColor = .black
                instructionsLabel?.fontName = "San-Francisco"
                instructionsLabel?.position = CGPoint(x: frame.midX, y: frame.midY + 100)
                addChild(instructionsLabel!)
                
                instructionsThing = SKLabelNode(text: "Tap all purple squares with the grey square to begin.")
                instructionsThing?.fontSize = 25
                instructionsThing?.fontColor = .black
                instructionsThing?.fontName = "San-Francisco"
                instructionsThing?.position = CGPoint(x: frame.midX, y: frame.midY + 25)
                instructionsThing?.horizontalAlignmentMode = .center
                instructionsThing?.numberOfLines = 2
                instructionsThing?.preferredMaxLayoutWidth = 300
                addChild(instructionsThing!)
                
                instructionsText = SKLabelNode(text: "Match them all to win!")
                instructionsText?.fontSize = 25
                instructionsText?.fontColor = .black
                instructionsText?.fontName = "San-Francisco"
                instructionsText?.position = CGPoint(x: frame.midX, y: frame.midY - 20)
                addChild(instructionsText!)
                
                restartButton = SKLabelNode(text: "Restart")
                restartButton?.fontSize = 20
                restartButton?.fontName = "Helvetica-Bold"
                restartButton?.fontColor = .gray
                restartButton?.position = CGPoint(x: frame.midX, y: frame.midY - 80) // Adjust the y position as needed
                restartButton?.name = "restartButton"
                addChild(restartButton!)
                
            }
        }
    }
    
    func restartGame() {
        // Reset arrays and dictionaries
        things.removeAll()
        thingColorIndexes.removeAll()
        thingHitCounts.removeAll()
        
        // Remove all nodes from the scene
        removeAllChildren()
        
        // Restart the game by calling `didMove(to:)`
        didMove(to: view!)
        
        isPaused = false
    }
    
}


