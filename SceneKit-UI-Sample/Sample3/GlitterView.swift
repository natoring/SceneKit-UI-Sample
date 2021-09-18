//
//  GlitterView.swift
//  SceneKit-UI-Sample
//
//  Created by kohei on 2021/09/18.
//

import UIKit
import SceneKit

public class GlitterView: SCNView {

    let surfaceShaderModifier = """
        #pragma arguments
        float glitter;

        #pragma transparent
        #pragma body

        float t = 2 * clamp(glitter - _surface.diffuseTexcoord.y / 2, 0.0, 0.5);
        _surface.diffuse.rgb += float3(pow(sin(3.14159 * t), 8) / 8.0);
    """

    let glitter = SCNNode()

    public override func awakeFromNib() {
        super.awakeFromNib()

        let scene = SCNScene()
        self.scene = scene

        glitter.geometry = SCNPlane(width: frame.size.width, height: frame.size.height)
        glitter.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "iosdc")
        glitter.geometry?.firstMaterial?.shaderModifiers = [
            .surface: surfaceShaderModifier
        ]
        glitter.geometry?.firstMaterial?.setValue(0.0, forKey: "glitter")

        scene.rootNode.addChildNode(glitter)
    }

    public func playAnimation() {
        let animation = CABasicAnimation(keyPath: "geometry.firstMaterial.glitter")
        animation.fromValue = 0.0
        animation.toValue   = 1.0
        animation.duration  = 1.0
        glitter.addAnimation(animation, forKey: nil)
    }
}

