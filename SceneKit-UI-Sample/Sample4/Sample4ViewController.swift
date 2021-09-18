//
//  Sample4ViewController.swift
//  SceneKit-UI-Sample
//
//  Created by kohei on 2021/09/19.
//

import UIKit

class Sample4ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "shaderModifiers - memoji"

        view.backgroundColor = .white

        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "smile")
        imageView.isUserInteractionEnabled = true
        imageView.addInteraction(StickerInteraction())
        view.addSubview(imageView)
    }
}
