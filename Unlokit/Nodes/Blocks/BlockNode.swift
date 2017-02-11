//
//  BlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 26/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

enum Side {
	case up
	case down
	case left
	case right
	
	static let all = [Side.up, Side.down, Side.left, Side.right]
	
	var position: CGPoint {
		switch self {
		case .up:
			return CGPoint(x: 0, y: 64)
		case .down:
			return CGPoint(x: 0, y: -64)
		case .left:
			return CGPoint(x: -64, y: 0)
		case .right:
			return CGPoint(x: 64, y: 0)
		}
	}
}

class BlockNode: SKSpriteNode {
	
	// For calculating the side that was contacted
	var up: CGPoint!
	var down: CGPoint!
	var left: CGPoint!
	var right: CGPoint!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.all

		// Get coordinates of sides of block
		let halfWidth = frame.width / 2
		let halfHeight = frame.height / 2
		
		up = CGPoint(x: frame.origin.x + halfWidth, y: frame.origin.y + frame.size.height)
		down = CGPoint(x: frame.origin.x + halfWidth, y: frame.origin.y)
		left = CGPoint(x: frame.origin.x, y: frame.origin.y + halfHeight)
		right = CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + halfHeight)
	}
	
	// Find side from contact
	func getSide(contact: SKPhysicsContact) -> Side {
		// Get point in block coordinates
		let point = convert(contact.contactPoint, from: scene!)
		
		let upDistance = getDistance(p1: point, p2: up)
		let downDistance = getDistance(p1: point, p2: down)
		let leftDistance = getDistance(p1: point, p2: left)
		let rightDistance = getDistance(p1: point, p2: right)
		
		let dict = [Side.up: upDistance, Side.down: downDistance, Side.left: leftDistance, Side.right: rightDistance]
		
		var side = Side.up
		
		// Large number to start
		var smallestDistance = CGFloat(UInt32.max)
		
		// Find smallest distance
		for (sideName, distance) in dict {
			if distance < smallestDistance {
				smallestDistance = distance
				side = sideName
			}
		}
		return side
	}
	
	// Difference between two points
	func getDistance(p1:CGPoint,p2:CGPoint) -> CGFloat {
		let xDist = (p2.x - p1.x)
		let yDist = (p2.y - p1.y)
		return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
	}
	
	func bounce(side: Side) {
		let bounce: SKAction
		
		switch side{
		case .up:
			bounce = SKAction.sequence([SKAction.moveBy(x: 0, y: -30, duration: 0.1), SKAction.moveBy(x: 0, y: 30, duration: 0.1)])
			bounce.timingMode = .easeInEaseOut
		case .down:
			bounce = SKAction.sequence([SKAction.moveBy(x: 0, y: 30, duration: 0.1), SKAction.moveBy(x: 0, y: -30, duration: 0.1)])
			bounce.timingMode = .easeInEaseOut
		case .left:
			bounce = SKAction.sequence([SKAction.moveBy(x: -30, y: 0, duration: 0.1), SKAction.moveBy(x: 30, y: 0, duration: 0.1)])
			bounce.timingMode = .easeInEaseOut
		case .right:
			bounce = SKAction.sequence([SKAction.moveBy(x: 30, y: 0, duration: 0.1), SKAction.moveBy(x: -30, y: 0, duration: 0.1)])
			bounce.timingMode = .easeInEaseOut
		}
		run(bounce)
		run(SoundFX.sharedInstance["block"]!)
	}
}
