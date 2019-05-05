// FirstScene.swift

import SpriteKit; import GameplayKit

class FirstScene: SKScene{

//    var gsBack = GameScene()
/* Would have liked to call Gamescene functions to iterate background view instead of
     copy + pasting code from Gamescene but couldn't due to time constraint. */
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.gray
        createTint()
        gameDirections()
        createRoad()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(FirstScene.lines), userInfo: nil, repeats: true)
    }
    
    func createTint(){
        // Black Opacity to make it have a menu fill
        let tint = SKShapeNode(rectOf: CGSize(width: 700, height: 500))
        tint.position = CGPoint(x: frame.midX, y: frame.midY)
        tint.fillColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        tint.strokeColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        tint.zPosition = 300
        addChild(tint)
        
    }
    func gameDirections(){
        let text1 = SKLabelNode(text: "Welcome!")
        text1.fontColor = SKColor.white
        text1.fontSize = 54
        text1.position = CGPoint(x: frame.midX, y: frame.height-150)
        text1.zPosition = 400
        text1.fontName = "HelveticaNeue-Bold"
        addChild(text1)
        
        let text2 = SKLabelNode(text: "Before you begin, there is sound in this game. It's somewhat loud, so I would lower the volume a bit.")
        text2.position = CGPoint(x: frame.midX, y: frame.height-180)
        text2.fontSize = 12
        text2.zPosition = 400
        text2.fontName = "HelveticaNeue-Bold"
        addChild(text2)
        let text3 = SKLabelNode(text: "Controls:")
        text3.fontColor = SKColor.yellow
        text3.position = CGPoint(x: frame.midX, y: frame.height-240)
        text3.fontSize = 44
        text3.zPosition = 400
        text3.fontName = "HelveticaNeue-Bold"
        addChild(text3)
        
        let text5 = SKLabelNode(text: "To move the car press the left or right arrows OR 'A' and 'D'")
        text5.position = CGPoint(x: frame.midX, y: frame.height-280)
        text5.fontSize = 14
        text5.zPosition = 400
        text5.fontName = "HelveticaNeue-Bold"
        addChild(text5)
        
        let text4 = SKLabelNode(text: "To Play:")
        text4.position = CGPoint(x: frame.midX, y: frame.height-350)
        text4.fontSize = 44
        text4.zPosition = 400
        text4.fontName = "HelveticaNeue-Bold"
        text4.fontColor = SKColor.yellow
        addChild(text4)
        
        let text6 = SKLabelNode(text: "Press Space")
        text6.position = CGPoint(x: frame.midX, y: frame.height-400)
        text6.fontSize = 14
        text6.zPosition = 400
        text6.fontName = "HelveticaNeue-Bold"
        addChild(text6)
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateStrips()
    }
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 49{
            self.view?.presentScene(GameScene(size: CGSize(width: 800, height: 600)), transition: SKTransition.push(with: .up , duration: 0.6))
            
        }
        
    }
//GameScene Repeat
    func createRoad(){
        let divider = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 5, height: frame.maxY))
        divider.position = CGPoint(x: frame.midX + 6, y: frame.midY)
        divider.zPosition = 1
        addChild(divider)
        let leftDivider = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 5, height: frame.maxY))
        leftDivider.position = CGPoint(x: frame.midX - 1, y: frame.midY)
        leftDivider.zPosition = 1
        addChild(leftDivider)
    }
    func updateStrips(){
        //Constantly updates positiom
        enumerateChildNodes(withName: "leftLine", using: {(roadStrip,stop) in
            let strip = roadStrip as! SKSpriteNode
            strip.position.y -= 30
            if strip.position.y < 0 {
                strip.removeFromParent()
            }
        })
        enumerateChildNodes(withName: "rightLine", using: {(roadStrip,stop) in
            let strip = roadStrip as! SKSpriteNode
            strip.position.y -= 30
            if strip.position.y < 0 {
                strip.removeFromParent()
            }
        })
        //Update calls this to decrease y position of traffic cars.
        enumerateChildNodes(withName: "TrafficCar", using: {(extraCars,stop) in
            let updateCar = extraCars as! SKSpriteNode
            updateCar.position.y -= 10
            if updateCar.position.y < 0 {
                updateCar.removeFromParent()
            }
        })
    }
    @objc func lines(){
        let leftLines = SKSpriteNode(color: SKColor.white, size: CGSize(width: 12, height: 70))
        leftLines.name = "leftLine"
        leftLines.position = CGPoint(x: frame.midX/2, y: frame.height)
        addChild(leftLines)
        
        let rightLines = SKSpriteNode(color: SKColor.white, size: CGSize(width: 12, height: 70))
        rightLines.name = "rightLine"
        rightLines.position = CGPoint(x: frame.width - frame.midX/2, y: frame.height)
        addChild(rightLines)
    }
}
