//
//  Sample2ViewController.swift
//  SceneKit-UI-Sample
//
//  Created by kohei on 2021/09/18.
//

import UIKit
import SceneKit

class Sample2ViewController: UIViewController {

    @IBOutlet private var scnView: SCNView!
    var confetti: SCNParticleSystem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "particle - confetti"

        throwConfetti()
    }

    /// confetti animation
    private func throwConfetti() {
        let scene = SCNScene()

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: -10, z: 10)
        scene.rootNode.addChildNode(cameraNode)

        if let scene = SCNScene(named: "confetti.scn", inDirectory: "") {
            let node: SCNNode = (scene.rootNode.childNode(withName: "particles", recursively: true)!)
            self.confetti = node.particleSystems?.first
        }

        if self.confetti != nil {
            let particleSystem:SCNParticleSystem = (self.confetti)!
            scene.rootNode.addParticleSystem(particleSystem)
        }

        self.scnView.scene = scene
    }
}

extension Sample2ViewController {
    static func instantiate() -> Sample2ViewController {
        let vc = UIStoryboard(name: "Sample2ViewController", bundle: nil).instantiateViewController(identifier: "sample2") as! Sample2ViewController
        return vc
    }
}
