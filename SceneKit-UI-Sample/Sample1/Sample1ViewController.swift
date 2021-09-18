//
//  Sample1ViewController.swift
//  SceneKit-UI-Sample
//
//  Created by kohei on 2021/09/18.
//

import UIKit
import SceneKit

class Sample1ViewController: UIViewController {

    @IBOutlet private var favButton: UIButton!

    private var scnView: SCNView?
    private var favParticle: SCNParticleSystem?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "particle - star"
        view.backgroundColor = .white

        guard let scene = SCNScene(named: "fav.scn", inDirectory: "") else { return }
        let node: SCNNode = (scene.rootNode.childNode(withName: "particles", recursively: true)!)
        self.favParticle = node.particleSystems?.first
    }

    @IBAction private func favButtonTapped() {

        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.favButton.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.favButton.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            } completion: { [weak self] _ in
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.favButton.transform = .identity
                } completion: { [weak self] _ in
                    self?.addFavParticle()

                    UIView.animate(withDuration: 0.6) { [weak self] in
                        self?.scnView!.alpha = 0
                    } completion: { [weak self] _ in
                        self?.scnView?.removeFromSuperview()
                        self?.scnView = nil
                    }
                }
            }
        }
    }

    private func addFavParticle() {
        let scene = SCNScene()

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)

        let particleSystem:SCNParticleSystem = (self.favParticle)!
        scene.rootNode.addParticleSystem(particleSystem)

        scnView = SCNView(frame: view.bounds)
        view.insertSubview(scnView!, belowSubview: favButton)

        scnView!.scene = scene
    }
}

extension Sample1ViewController {
    static func instantiate() -> Sample1ViewController {
        let vc = UIStoryboard(name: "Sample1ViewController", bundle: nil).instantiateViewController(identifier: "sample1") as! Sample1ViewController
        return vc
    }
}
