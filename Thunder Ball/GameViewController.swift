//
//  GameViewController.swift
//  Thunder Ball
//
//  Created by Drew Nibeck on 9/15/15.
//  Copyright (c) 2015 Thunder Ball. All rights reserved.
//

import SceneKit

class GameViewController: UIViewController {
  //The master scene as of now. Can implement stage-changer by creating different scenes.
  let scene = GameScene()
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    // retrieve the SCNView
    let scnView = self.view as! SCNView
        
    // set the scene to the view
    scnView.scene = scene
        
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
        
    // show statistics such as fps and timing information
    scnView.showsStatistics = true
        
    // configure the view
    scnView.backgroundColor = UIColor.blackColor()
    
    //Phsyics shit
    self.scene.physicsWorld.gravity = SCNVector3Make(0, -10, 0)
  }
  
  @IBAction func handleTap(sender: AnyObject) {
    //Applies a random impulse on the lamp to make it swing a bit.
    let cone = scene.rootNode.childNodeWithName("coneNode", recursively: true)!
    
    let randX = Float.random(-25, max: 25)
    let randY = Float.random(-25, max: 25)
    let randZ = Float.random(-25, max: 25)
    
    let vector = SCNVector3Make(randX, randY, randZ)
    
    cone.physicsBody!.applyForce(vector, atPosition: cone.position, impulse: true)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Release any cached data, images, etc that aren't in use.
  }

}
