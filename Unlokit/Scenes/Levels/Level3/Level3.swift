//
//  Level3.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit

class Level3: Level {
	// Set number of tools for level
	override func setupToolsForLevel() {
		for tool in toolIcons {
			switch tool.type! {
			case .spring:
				tool.number = 5
			case .glue:
				tool.number = 5
			case .fan:
				tool.number = 5
			case .gravity:
				tool.number = 5
			case .time:
				tool.number = 0
			}
		}
	}
}
