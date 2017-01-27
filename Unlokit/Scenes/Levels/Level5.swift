//
//  Level5.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit

class Level5: Level {
	// Set number of tools for level
	override func setupToolsForLevel() {
		for (type, tool) in toolIcons {
			switch type {
			case .spring:
				tool.number = 4
			case .bomb:
				tool.number = 2
			case .glue:
				tool.number = 0
			case .fan:
				tool.number = 0
			case .gravity:
				tool.number = 0
			}
		}
	}
}
