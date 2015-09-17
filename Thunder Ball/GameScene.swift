//
//  GameScene.swift
//  Thunder Ball
//
//  Created by Drew Nibeck on 9/16/15.
//  Copyright © 2015 Thunder Ball. All rights reserved.
//

import SceneKit

class GameScene: SCNScene {
  let geometriesNode = SCNNode()
  
  override init() {
    super.init()
    
    self.setupScene()
  }
  
  private func setupScene() {
    //Create ambient light for the whole scene
    let ambientLight = SCNLight()
    ambientLight.type = SCNLightTypeAmbient
    ambientLight.color = UIColor.darkGrayColor()
    
    let ambientNode = SCNNode()
    ambientNode.light = ambientLight
    
    self.rootNode.addChildNode(ambientNode)
    
    //Create a plane
    let plane = SCNBox(width: 50, height: 0, length: 50, chamferRadius: 0)
    plane.firstMaterial!.diffuse.contents = UIColor.darkGrayColor()
    plane.firstMaterial!.specular.contents = UIColor.whiteColor()
    
    let planeNode = SCNNode(geometry: plane)
    planeNode.position = SCNVector3Make(0, 0, 0)
    
    geometriesNode.addChildNode(planeNode)
    
    //Create a new hanging light fixture
    let lightNode = createLightFixture()
    self.rootNode.addChildNode(lightNode)
    
    self.rootNode.addChildNode(geometriesNode)
    
    //Add a little cube under the light to demonstrate shadows
    let cube = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
    cube.firstMaterial!.specular.contents = UIColor.redColor()
    cube.firstMaterial!.diffuse.contents  = UIColor.whiteColor()
    
    let cubeNode = SCNNode(geometry: cube)
    cubeNode.position = SCNVector3Make(0, 5, 0)
    
    self.rootNode.addChildNode(cubeNode)
  }
  
  //Creates a cieling lamp that swings from the "cieling"
  func createLightFixture() -> SCNNode {
    //Returned node
    let tempNode = SCNNode()
    
    //Geometries
    let cone = SCNCone(topRadius: 1, bottomRadius: 2, height: 1)
    let bulb = SCNSphere(radius: 0.5) //The bulb serves as a "focal-point" for the light. Not visible as it is inside the cone.
    
    //Texture properties
    cone.firstMaterial!.specular.contents = UIColor.darkGrayColor()
    cone.firstMaterial!.diffuse.contents  = UIColor.whiteColor()
    
    //Bulb has visible properties to see if it hangs out of the lamp. If it does, it needs repositioned.
    bulb.firstMaterial!.specular.contents = UIColor.darkGrayColor()
    bulb.firstMaterial!.diffuse.contents  = UIColor.darkGrayColor()
    
    //Lights
    let light = SCNLight()
    
    //Light properites
    light.type = SCNLightTypeSpot
    light.castsShadow = true
    
    light.categoryBitMask = 0b1
    
    //Nodes
    let coneNode = SCNNode(geometry: cone)
    let bulbNode = SCNNode(geometry: bulb)
    let lightNode = SCNNode()
    
    //Properties
    coneNode.position = SCNVector3Make(0, 15, 0)
    coneNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: SCNPhysicsShape(geometry: coneNode.geometry!, options: nil))
    coneNode.name = "coneNode"
    
    bulbNode.position = SCNVector3Make(0, -0.5, 0) //Child of coneNode, so coords are in coneNode's coordinate-space
    
    lightNode.light = light
    lightNode.position = SCNVector3Make(0, 0, 0)   //Child of coneNode, so coords are in coneNode's coordinate-space
    
    //Children
    coneNode.addChildNode(bulbNode)
    coneNode.addChildNode(lightNode)
    
    tempNode.addChildNode(coneNode)
    
    //Constraints
    let lookAtConstraint = SCNLookAtConstraint(target: bulbNode)
    lookAtConstraint.gimbalLockEnabled = true //MUST BE TRUE. Without it, gimbal lock will not occur and the light will appear to "jump" around.
    
    //Force the spot light to always point towards bulb, making it like an actual lamp (non-omni-directional)
    lightNode.constraints = [lookAtConstraint]
    
    //Physics
    let joint = SCNPhysicsBallSocketJoint(body: coneNode.physicsBody!, anchor: SCNVector3Make(0, 30, 0))
    
    //Create a "rope" for the lamp to dangle from. Used for when taps occur. See touchesBegan(withEvent:).
    self.physicsWorld.addBehavior(joint)
    
    return tempNode
  }
  
  

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
