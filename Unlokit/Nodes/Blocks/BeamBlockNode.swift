//
//  BeamBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 12/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BeamBlockNode: BlockNode {
	var pinnedBlock: BlockNode?

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		physicsBody?.categoryBitMask = Category.zero
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.all// ^ Category.blocks
	}

	func setup(scene: GameScene) {

		var blocks = [BlockNode]()
		for child in children {
			if let ref = child as? SKReferenceNode {
				if let block = ref.children.first?.children.first as? BlockNode {
					blocks.append(block)
				}
			} else if let block = child as? BlockNode {
				blocks.append(block)
			}
		}
		// Sort block by x position
		blocks.sort {
			$0.convert($0.position, to: scene).x > $1.convert($1.position, to: scene).x
		}

		var lastBlock: BlockNode?
		for block in blocks {
			// Remove existing joints
			if !block.physicsBody!.joints.isEmpty, let joint = block.physicsBody?.joints[0] {
				scene.physicsWorld.remove(joint)
			}

			if block.physicsBody!.pinned {
				pinnedBlock = block
			}

			block.physicsBody?.isDynamic = true
			block.beamNode = self

			if lastBlock == nil {
				lastBlock = block
			} else {
				let anchor = scene.convert(block.position, from: block.parent!)

				let physicsJoint = SKPhysicsJointPin.joint(withBodyA: block.physicsBody!,
				                                           bodyB: lastBlock!.physicsBody!,
				                                           anchor: anchor)
				physicsJoint.shouldEnableLimits = true

				scene.physicsWorld.add(physicsJoint)

				lastBlock = block
			}
		}

		lastBlock = nil
		getDataFromParent()
	}

	private func getDataFromParent() {
		var data: NSDictionary?

		// Find user data from parents
		var tempNode: SKNode = self
		while !(tempNode is SKScene) {
			if let userData = tempNode.userData {
				data = userData
			}
			tempNode = tempNode.parent!
		}

		// Set instance properties
		if let torque = data?["torque"] as? CGFloat {
			pinnedBlock?.physicsBody?.applyAngularImpulse(torque)
		}
	}
}