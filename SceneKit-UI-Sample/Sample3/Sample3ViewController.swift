//
//  Sample3ViewController.swift
//  SceneKit-UI-Sample
//
//  Created by kohei on 2021/09/18.
//

import UIKit

class Sample3ViewController: UIViewController {

    @IBOutlet private var glitterView: GlitterView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "shaderModifiers - 1"

        let timer = Timer.scheduledTimer(timeInterval: 3.0,
                                         target: self,
                                         selector: #selector(update),
                                         userInfo: nil,
                                         repeats: true)
        timer.fire()
    }

    @objc private func update() {
        glitterView.playAnimation()
    }
}

extension Sample3ViewController {
    static func instantiate() -> Sample3ViewController {
        let vc = UIStoryboard(name: "Sample3ViewController", bundle: nil).instantiateViewController(identifier: "sample3") as! Sample3ViewController
        return vc
    }
}
