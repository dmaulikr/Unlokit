//
//  GravityToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 24/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class GravityToolNode: ToolNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		type = .gravity
	}
	
	override func setupPhysics(shadowed isShadowed: Bool) {
		super.setupPhysics(shadowed: isShadowed)

		physicsBody?.categoryBitMask = Category.gravityTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.mtlBlock |
										  Category.bncBlock | Category.gluBlock | Category.breakBlock
	}
}
