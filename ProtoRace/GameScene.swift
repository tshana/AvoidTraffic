// GameScene.swift

import SpriteKit; import GameplayKit; import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    let carTexture = SKTexture(); let car = SKSpriteNode()
    var score = 0; var minutes = 0; var seconds = 0
    let crashSound = SKAction.playSoundFileNamed("crash.wav", waitForCompletion: true)
    let passSound = SKAction.playSoundFileNamed("pass.wav", waitForCompletion: false)

    
    var endAudioPlayer: AVAudioPlayer? = nil
    func loadAudio() {
        let path = Bundle.main.path(forResource: "crash", ofType: "wav")
        let audioURL = URL(fileURLWithPath: path!)
        do {endAudioPlayer = try AVAudioPlayer(contentsOf: audioURL)}
        catch { print("unable to load audio file")}
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.gray
        physicsWorld.contactDelegate = self
        createCar()
        createRoad()
        createLabel()
        lines()
        trafficCars()
//Continuously makes white lines + Makes Cars + Timer for score
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameScene.lines), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(GameScene.trafficCars), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.scoreTime), userInfo: nil, repeats: true)

        loadAudio()
    }
    
//Player controls car with keyboard
    func createCar(){
        let carTexture = SKTexture(imageNamed: "car.png"); let car = SKSpriteNode(texture: carTexture)
        car.name = "Cars"
        car.position = CGPoint(x: frame.midX + 100, y: 100)
        car.size = CGSize(width: 64, height: 84)
        car.zRotation = 0.0
        car.zPosition = 5.0
        
        let body = SKPhysicsBody(texture: carTexture, size: car.size)
        
        body.categoryBitMask = 0x1 << 0
        body.collisionBitMask = 0
        body.contactTestBitMask = 1
        body.affectedByGravity = false
        body.usesPreciseCollisionDetection = true
//        body.isDynamic = true
        car.physicsBody = body
        addChild(car)
        
       
    }

//Car nodes that make traffic
    @objc func trafficCars(){
        let cop = SKTexture(imageNamed: "trafficCar1.png"); let tCar = SKTexture(imageNamed: "trafficCar4.png")
        let truck = SKTexture(imageNamed: "trafficCar3.png")
        
        var trafficCar : SKSpriteNode; var body : SKPhysicsBody
        let randomizer = Int.random(in: 0...10)
// Randomizes type of traffic car
        switch randomizer {
        case 0...3:  trafficCar = SKSpriteNode(texture: cop);  body = SKPhysicsBody(texture: cop, size: trafficCar.size)
        case 4...6:  trafficCar = SKSpriteNode(texture: tCar); body = SKPhysicsBody(texture: tCar, size: trafficCar.size)
        case 7...10: trafficCar = SKSpriteNode(texture: truck);body = SKPhysicsBody(texture: truck, size: trafficCar.size)
        default:     trafficCar = SKSpriteNode(texture: tCar); body = SKPhysicsBody(texture: tCar, size: trafficCar.size)
        }
// Randomizes position in the 4 lanes /* TO DO - Find a better way to randomize. Cars sorta have a pattern, */
        switch Int.random(in: 1...13) {
        case 1...3:   trafficCar.position.x = 700
        case 4...6:   trafficCar.position.x = 100
        case 7...9:   trafficCar.position.x = 300
        case 10...13: trafficCar.position.x = 500
        default: trafficCar.position.x = 500
        }
        trafficCar.name = "TrafficCar"
        trafficCar.size = CGSize(width: 184, height: 104)
        trafficCar.position.y = frame.height
        
        body.categoryBitMask = 0x1 << 1
        body.collisionBitMask = 0x1 << 0
        body.contactTestBitMask = 1
        body.usesPreciseCollisionDetection = true
        trafficCar.physicsBody = body
        addChild(trafficCar)
    }
    //Yellow divider in the middle
    func createRoad(){
        let divider = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 5, height: frame.maxY))
        divider.position = CGPoint(x: frame.midX + 6, y: frame.midY)
        addChild(divider)
        let leftDivider = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 5, height: frame.maxY))
        leftDivider.position = CGPoint(x: frame.midX - 1, y: frame.midY)
        addChild(leftDivider)
    }
    //Update calls this to decrease y position of white lines + Traffic Cars.
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
    //White line shapes
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
    override func update(_ currentTime: TimeInterval) {
        updateStrips()
        updateScoreLabel()
        
//Catches the car to be within the frame
        if let car = childNode(withName: "Cars"){
            if car.position.x < 99{car.position.x = 100}
            else if car.position.x > 701{car.position.x = 700}
        }
    }
    override func keyDown(with event: NSEvent) {
        /* Right - Left */
        if let car = childNode(withName: "Cars"){
            if event.keyCode == 124 || event.keyCode == 2{
                car.run(SKAction.moveBy(x: 200, y: 0, duration: 0.1))
                run(passSound)
            }
            else if event.keyCode == 123 || event.keyCode == 0{
                car.run(SKAction.moveBy(x: -200, y: 0, duration: 0.1))
                run(passSound)
            }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        guard let nameA = nodeA.name, let nameB = nodeB.name else { return }
        print("A \(nameA)"); print("B \(nameB)")

        if nameA == "Cars" && nameB == "TrafficCar"{
            
            isPaused = true
            nodeB.removeFromParent()
            endAudioPlayer?.play()
            let store = UserDefaults.standard
            store.set(score, forKey: "Total") 
            
            self.view?.presentScene(Greeting(size: CGSize(width: 800, height: 600)))
            
        }else{ print("Not Detected")
        }
    }
    func createLabel(){
        let textNode = SKLabelNode(text: "Score: \(score)")
        textNode.position = CGPoint(x: 180, y: 0 )
        textNode.fontColor = SKColor.white
        textNode.name = "Score"
        textNode.fontSize = 48
        textNode.zPosition = 5
        
        addChild(textNode)
//        let hitcount = SKLabelNode(text: "Hit Count: \(hitCount)")
//        hitcount.position = CGPoint(x: frame.midX, y: frame.midY)
//        hitcount.name = "hc"
//        addChild(hitcount)
        
    }
    func updateScoreLabel(){
        if let textNode = childNode(withName: "Score") as? SKLabelNode{
            let tmpScore = String(format:"%02i:%02i", minutes, seconds)
            textNode.text = "Score - \(tmpScore)"}
//        if let textNode = childNode(withName: "hc") as? SKLabelNode{textNode.text = "Hit Count: \(hitCount)"}
    }
    @objc func scoreTime(){
        score += 1
         minutes = score / 60 % 60
         seconds = score % 60
    }
}
