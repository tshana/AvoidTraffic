// Greeting.swift

import SpriteKit; import GameplayKit

class Greeting: SKScene{
    
    override func didMove(to view: SKView) {
        let store = UserDefaults.standard
        let scorePrev = store.value(forKey: "Total") as? Int
        
        let tmpMin = scorePrev! / 60 % 60
        let tmpSec = scorePrev! % 60
        
        let text = SKLabelNode(text: "Game Over!")
        text.position = CGPoint(x: frame.midX, y: frame.midY+100)
        text.fontColor = SKColor.red
        text.fontName = "HelveticaNeue-Bold"
        text.fontSize = 32
        addChild(text)
        
        let t1 = SKLabelNode(text: "Score: \(tmpMin) minutes \(tmpSec) seconds")
        t1.position = CGPoint(x: frame.midX, y: frame.midY+50)
        t1.fontColor = SKColor.green
        t1.fontName = "HelveticaNeue-Bold"
        t1.fontSize = 24
        addChild(t1)
        
        let t2 = SKLabelNode(text: "Press Space or F to play agian.")
        t2.position = CGPoint(x: frame.midX, y: frame.midY)
        t2.fontColor = SKColor.white
        t2.fontName = "HelveticaNeue-Bold"
        t2.fontSize = 24
        addChild(t2)
        
        let t3 = SKLabelNode(text: "Press Q to go to the Main Screen")
        t3.position = CGPoint(x: frame.midX, y: frame.midY-35)
        t3.fontColor = SKColor.white
        t3.fontName = "HelveticaNeue-Bold"
        t3.fontSize = 24
        addChild(t3)
        

    }
    
    override func keyDown(with event: NSEvent) {
//Space or F
        if event.keyCode == 49 || event.keyCode == 3 {self.view?.presentScene(GameScene(size: CGSize(width: 800, height: 600)))}
//Q
        else if event.keyCode == 12{ self.view?.presentScene(FirstScene(size: CGSize(width: 800, height: 600)))}
    }
}
