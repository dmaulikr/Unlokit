//
//  FireButtonNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 11/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

protocol CanBeFired {
	func engage(_ controller: ControllerNode, completion: @escaping () -> ())
	func disengage(_ controller: ControllerNode)
	func prepareForFiring(controller: ControllerNode)

	// To stop tools being stuck
	func startTimer(glueBlock: GlueBlockNode, side: Side)
	func startTimer()
}

class FireButtonNode: SKSpriteNode {
	
	//MARK: Variables
	let nonPressedtexture = SKTexture(image: #imageLiteral(resourceName: "FireButton"))
	let pressedTexture = SKTexture(image: #imageLiteral(resourceName: "FireButtonPressed"))
    
    var pressed = false
	var objectToFire: CanBeFired?
	
	// Must be initalised from scene
	var controller: ControllerNode!
	var cannon: SKSpriteNode!
	
    // Used for initialising from file
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		isUserInteractionEnabled = true
    }
	
    private func press() {
        pressed = !pressed
		if pressed {
			texture = pressedTexture
		} else {
			texture = nonPressedtexture
		}
    }
    
	fileprivate func fire(scene: GameScene) {
		// Make sure controller is occupied and object is not nil and is a SKSpriteNode
		guard controller.isOccupied, let sprite = objectToFire as? SKSpriteNode else {
			return
		}
		
		// Shenanigans for using both protocol and type properties
		// Prepare for firing
		objectToFire?.prepareForFiring(controller: controller)
		//objectToFire is of type 'CanBeFired', object is SKSpriteNode, both reference same object
		
        // Speed of firing
        let speed: CGFloat = 50
		
		// Compensation
		let angle = Float(controller.zRotation + CGFloat(90).degreesToRadians())
		
        sprite.zRotation = CGFloat(angle)
		
		// Get vector to fire to
        let dx = CGFloat(cosf(angle)) * speed
        let dy = CGFloat(sinf(angle)) * speed
		
		// Apply impulse based on angle
        sprite.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
		
		cannon.run(SoundFX.sharedInstance["cannon"]!)
		
		let recoilAction = SKAction.sequence([SKAction.moveBy(x: 0, y: -70, duration: 0.03), SKAction.moveBy(x: 0, y: 70, duration: 0.2)])
		cannon.run(recoilAction) // Make cannon recoil
		objectToFire = nil
		
		// To prevent camera jerk
		scene.isJustFired = true
		run(SKAction.sequence([
			SKAction.wait(forDuration: RCValues.sharedInstance.cameraWait),
			SKAction.run { scene.isJustFired = false }
			]))
		
		// So camera can follow the sprite
		scene.nodeToFollow = sprite
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
		// Check if touch is in button
		let location = touches.first!.location(in: parent!)
		if frame.contains(location), let scene = scene as? GameScene {
			fire(scene: scene)
		}
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
}

class FireButtonTutorial: FireButtonNode {
	override func fire(scene: GameScene) {
		super.fire(scene: scene)
		// Notify the scene when it has fired
		if let scene = scene as? TutorialScene {
			scene.goToNextStage(action: .fire)
		} else {
			fatalError("Tutorial not initiated")
		}
	}
}
