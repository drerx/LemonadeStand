//
//  Supplies.swift
//  LemonadeStand
//
//  Created by Kilian Koeltzsch on 17/09/14.
//  Copyright (c) 2014 Kilian Koeltzsch. All rights reserved.
//

import Foundation

struct Supplies {

	var money = 0
	var lemons = 0
	var iceCubes = 0

	init(money: Int, lemons: Int, iceCubes: Int) {
		self.money = money
		self.lemons = lemons
		self.iceCubes = iceCubes
	}
}