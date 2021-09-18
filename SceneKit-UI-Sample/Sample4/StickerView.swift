//
//  StickerView.swift
//  SceneKit-UI-Sample
//
//  Created by kohei on 2021/09/19.
//

import UIKit
import SceneKit

class StickerView: UIView {

    let geometryModifier = """
        #pragma arguments
        float peeled;
        float liftDistance;

        #pragma transparent
        #pragma body

        float t = 2 * clamp(peeled - _geometry.texcoords[0].y / 2, 0.0, 0.5);

        if (t < 0.5) {
            t = (4 * t * t * t);
        } else {
            t = ((t - 1) * (2 * t - 2) * (2 * t - 2) + 1);
        }

        t = round(t * 1000.0) / 1000.0;
        _geometry.position.xyz += _geometry.normal * liftDistance * t;
    """

    let surfaceModifier = """
        #pragma arguments
        float peeled;

        #pragma transparent
        #pragma body

        float t = 2 * clamp(peeled - _surface.diffuseTexcoord.y / 2, 0.0, 0.5);
        _surface.diffuse.rgb += float3(pow(sin(3.14159 * t), 8) / 8.0);
    """

    let sceneView: SCNView

    let reflection: SCNNode

    let sticker: SCNNode

    var image: UIImage? {
        didSet {
            sticker.geometry?.firstMaterial?.diffuse.contents = image
            reflection.geometry?.firstMaterial?.diffuse.contents = image
        }
    }

    private(set) var isPeeledOff: Bool = false

    override init(frame: CGRect) {
        sceneView = SCNView(frame: frame)
        sceneView.frame.origin = .zero

        var scaled = frame.size
        scaled.width  /= 2.0
        scaled.height /= 2.0

        sticker = SCNNode(geometry: SCNPlane(width: scaled.width, height: scaled.height))
        reflection = SCNNode(geometry: SCNPlane(width: scaled.width, height: scaled.height))

        super.init(frame: frame)

        clipsToBounds = false

        sceneView.isPlaying = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .clear

        let scene = SCNScene()
        sceneView.scene = scene

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()

        let fov = cameraNode.camera!.fieldOfView

        let cameraDistance = max(frame.size.width, frame.size.height) / (2 * tan(fov / 2 * .pi / 180))

        cameraNode.position = SCNVector3(x: 0, y: 0, z: Float(cameraDistance))
        cameraNode.camera!.zFar = ceil(Double(cameraDistance))
        scene.rootNode.addChildNode(cameraNode)

        let parent = SCNNode()
        scene.rootNode.addChildNode(parent)

        parent.addChildNode(sticker)

        sticker.geometry?.firstMaterial?.setValue(0.0, forKey: "peeled")
        sticker.geometry?.firstMaterial?.setValue(cameraDistance * 0.25, forKey: "liftDistance")
        sticker.geometry?.firstMaterial?.shaderModifiers = [
            .surface: surfaceModifier,
            .geometry: geometryModifier
        ]

        let tesselator = SCNGeometryTessellator()
        tesselator.edgeTessellationFactor   = 50
        tesselator.insideTessellationFactor = 50

        sticker.geometry?.tessellator = tesselator
        sticker.geometry?.firstMaterial?.readsFromDepthBuffer = false

        parent.addChildNode(reflection)

        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")!
        gaussianBlurFilter.name = "blur"
        gaussianBlurFilter.setValue(0.0, forKey: "inputRadius")

        reflection.filters = [ gaussianBlurFilter ]

        addSubview(sceneView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        let transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        sceneView.frame = bounds.applying(transform)
        sceneView.center.x = bounds.midX
        sceneView.center.y = bounds.midY
    }

    public func stickerAnimation(isPeeledOff: Bool, animated: Bool = false, start: @escaping () -> Void = {}, completion: @escaping () -> Void = {}) {
        self.isPeeledOff = isPeeledOff

        let peeled: CAAnimation = {
            sticker.geometry?.firstMaterial?.setValue(isPeeledOff ? 1.0 : 0.0, forKey: "peeled")

            let animation = CABasicAnimation(keyPath: "geometry.firstMaterial.peeled")
            animation.fromValue = isPeeledOff ? 0.0 : 1.0
            animation.toValue   = isPeeledOff ? 1.0 : 0.0
            animation.duration  = 1

            return animation
        }()
        sticker.addAnimation(peeled, forKey: nil)

        let blur: CAAnimation = {
            reflection.filters?.first?.setValue(isPeeledOff ? 10.0 : 0.0, forKey: "inputRadius")

            let animation = CABasicAnimation(keyPath: "filters.blur.inputRadius")
            animation.duration       = 2.0
            animation.fillMode       = .backwards
            animation.fromValue      = isPeeledOff ? 0.0 : 10.0
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.toValue        = isPeeledOff ? 10.0 : 0.0
            return animation
        }()
        let transparency: CAAnimation = {
            reflection.geometry?.firstMaterial?.transparency = 0.5

            let delay = isPeeledOff ? 1 / 2.5 : 0
            let animation = CABasicAnimation(keyPath: "geometry.firstMaterial.transparency")
            animation.beginTime      = delay
            animation.duration       = 1 - delay
            animation.fillMode       = .backwards
            animation.fromValue      = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.toValue        = 0.5
            return animation
        }()
        let transform: CAAnimation = {
            let identity   = SCNMatrix4Identity
            let translated = SCNMatrix4MakeTranslation(0, -30, 0)

            reflection.transform = isPeeledOff ? translated : identity

            let delay = isPeeledOff ? 1 / 2.5 : 0
            let animation = CABasicAnimation(keyPath: "transform")
            animation.beginTime      = delay
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fromValue      = isPeeledOff ? identity : translated
            animation.toValue        = isPeeledOff ? translated : identity
            animation.duration       = 1 - delay
            animation.fillMode       = .backwards
            return animation
        }()

        let group = CAAnimationGroup()
        group.animations = [blur, transparency, transform]
        group.duration = 1
        reflection.addAnimation(group, forKey: nil)

        sceneView.scene?.rootNode.runAction(SCNAction()) {
            start()
        }
        sceneView.scene?.rootNode.runAction(SCNAction.wait(duration: 1)) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
