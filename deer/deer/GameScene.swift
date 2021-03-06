//
//  GameScene.swift
//  deer
//
//  Created by Gareth on 19.09.17.
//  Copyright © 2017 Gareth. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameScene: SCNScene, SCNSceneRendererDelegate {
    var deer = SCNNode()
    var timeLast: Double?
    var previousRotation = 0.0
    var rotationConstant = 0.6
    
    convenience init(create: Bool) {
        self.init()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        if let cam = cameraNode.camera {
            cam.usesOrthographicProjection = true
        }
        cameraNode.position = SCNVector3(0, 1, 5)
        
        // root node always accessible as we are subclassing scnscene
        rootNode.addChildNode(cameraNode)
        
        
        // lights
        let spotLightNode = SCNNode()
        spotLightNode.light = SCNLight()
        if let light = spotLightNode.light {
            light.type = .spot
            light.attenuationEndDistance = 50
            light.attenuationStartDistance = 0
            light.attenuationFalloffExponent = 2
            light.color = UIColor(
                red: 1,
                green: 0x2b/255.0,
                blue: 0x71/255.0,
                alpha: 1
            )
        }
        spotLightNode.position = SCNVector3(0,2,2)
        rootNode.addChildNode(spotLightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        if let amLight = ambientLightNode.light {
            amLight.type = .ambient
            amLight.color = UIColor.white
        }
        rootNode.addChildNode(ambientLightNode)
        
        // node to look at
        let spotLookAtNode = SCNNode()
        spotLightNode.position = SCNVector3Zero
        
        // look at look at node
        spotLightNode.constraints = [SCNLookAtConstraint(target: spotLookAtNode)]
        cameraNode.constraints = [SCNLookAtConstraint(target: spotLookAtNode)]
        
        // load the deer
        let deerScene = SCNScene(named: "art.scnassets/Deer.dae")
        if let deerSceneUnwrapped = deerScene {
            deer = deerSceneUnwrapped.rootNode.childNode(withName: "Deer", recursively: true)!
            
            
            deer.rotation = SCNVector4(
                x: 0,
                y: 1,
                z: 0,
                w: Float(-Double.pi / 4)
            )
            
            // wrapper for scaling
            let nodeWrapper = SCNNode()
            nodeWrapper.scale = SCNVector3(2,2,2)
            nodeWrapper.addChildNode(deer)
            rootNode.addChildNode(nodeWrapper)
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // this is game loop!
        let dt: Double
        
        if let lt = timeLast {
            dt = time - lt
        } else {
            dt = 0
        }
        
        let rotationAbout = (rotationConstant * dt) + previousRotation
        previousRotation = rotationAbout
        
        deer.rotation = SCNVector4(
            x: 0,
            y: 1,
            z: 0,
            w: Float(-rotationAbout)
        )
        
        timeLast = time
        
        print("\(dt * 1000)")
    }
    
}

