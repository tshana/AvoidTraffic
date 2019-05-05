//  ViewController.swift

import Cocoa
import SpriteKit

class ViewController: NSViewController {
    @IBOutlet var skView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.skView {
            let scene = FirstScene(size: view.bounds.size)
            print(view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

