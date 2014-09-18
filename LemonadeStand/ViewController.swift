//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Kilian Koeltzsch on 16/09/14.
//  Copyright (c) 2014 Kilian Koeltzsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var playerMoneyLabel: UILabel!
	@IBOutlet weak var playerLemonLabel: UILabel!
	@IBOutlet weak var playerIceLabel: UILabel!

	var supplies = Supplies(money: 10, lemons: 1, iceCubes: 1)
	var price = Price()

	@IBOutlet weak var shopLemonLabel: UILabel!
	@IBOutlet weak var shopIceLabel: UILabel!

	var shopLemons = 1
	var shopIce = 1

	@IBOutlet weak var mixLemonLabel: UILabel!
	@IBOutlet weak var mixIceLabel: UILabel!

	var mixLemons = 0
	var mixIce = 0

	@IBOutlet weak var customerSatisfactionLabel: UILabel!
	@IBOutlet weak var weatherImageView: UIImageView!

	var weatherArray = [[-10, -9, -5, -7], [5, 8, 10, 9], [22, 25, 27, 23]]
	var weatherToday = [0, 0, 0, 0]

	override func viewDidLoad() {
		super.viewDidLoad()

		simulateWeatherToday()

		updateView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func buyLemonsButton(sender: UIButton) {
		if supplies.money >= price.lemon {
			supplies.money -= price.lemon
			supplies.lemons++
			shopLemons++
			updateView()
		} else {
			showAlertWithText(header: "You're broke!", message: "You can't afford a lemon.")
		}
	}
	@IBAction func sellLemonsButton(sender: UIButton) {
		if supplies.lemons > 0 {
			supplies.lemons--
			shopLemons--
			supplies.money += price.lemon
			updateView()
		} else {
			showAlertWithText(header: "No lemons, dude.", message: "You can't sell a lemon you don't have.")
		}
	}

	@IBAction func buyIceButton(sender: UIButton) {
		if supplies.money >= price.iceCube {
			supplies.money -= price.iceCube
			supplies.iceCubes++
			shopIce++
			updateView()
		} else {
			showAlertWithText(header: "You're broke!", message: "You can't even afford an ice cube. Sucks for you, man.")
		}
	}
	@IBAction func sellIceButton(sender: UIButton) {
		if supplies.iceCubes > 0 {
			supplies.iceCubes--
			shopIce--
			supplies.money += price.iceCube
			updateView()
		} else {
			showAlertWithText(header: "Nah, man.", message: "How you gonna sell ice if you don't have no ice?")
		}
	}

	@IBAction func addLemonsButton(sender: UIButton) {
		if supplies.lemons > 0 {
			supplies.lemons--
			shopLemons--
			mixLemons++
			updateView()
		}
	}
	@IBAction func removeLemonsButton(sender: UIButton) {
		if mixLemons > 0 {
			mixLemons--
			supplies.lemons++
			shopLemons++
			updateView()
		}
	}

	@IBAction func addIceButton(sender: UIButton) {
		if supplies.iceCubes > 0 {
			supplies.iceCubes--
			shopIce--
			mixIce++
			updateView()
		}
	}
	@IBAction func removeIceButton(sender: UIButton) {
		if mixIce > 0 {
			mixIce--
			supplies.iceCubes++
			shopIce++
			updateView()
		}
	}

	@IBAction func startDayButton(sender: UIButton) {

		if mixLemons < 1 || mixIce < 1 {
			showAlertWithText(message: "You can't sell lemonade without lemons or ice.")
		} else {

			let average = findAverage(weatherToday)
			let customers = Int(rand()) % average
			var moneyEarned = 0

			let lemonadeRatio = Float(mixLemons) / Float(mixIce)
			println("Lemonade Ratio: \(lemonadeRatio)")

			for x in 0...customers {
				let preference = Double(Int(rand()) % 100) / 100
				println("\(preference)")

				if preference < 0.4 && lemonadeRatio > 1 {
					supplies.money++
					moneyEarned++
				} else if preference > 0.6 && lemonadeRatio < 1 {
					supplies.money++
					moneyEarned++
				} else if preference <= 0.6 && preference >= 0.4 && lemonadeRatio == 1 {
					supplies.money++
					moneyEarned++
				} else {
					// Not much happening here...
				}
			}

			// Reset the mix.
			mixLemons = 0
			mixIce = 0

			customerSatisfactionLabel.hidden = false
			customerSatisfactionLabel.text = "You made $\(moneyEarned) today from \(moneyEarned) happy customers!"
			moneyEarned = 0

			simulateWeatherToday()
			updateView()
		}
	}

	func updateView() {
		playerMoneyLabel.text = "$\(supplies.money)"
		if supplies.lemons == 1 {
			playerLemonLabel.text = "\(supplies.lemons) Lemon"
		} else {
			playerLemonLabel.text = "\(supplies.lemons) Lemons"
		}
		if supplies.iceCubes == 1 {
			playerIceLabel.text = "\(supplies.iceCubes) Ice Cube"
		} else {
			playerIceLabel.text = "\(supplies.iceCubes) Ice Cubes"
		}
		shopLemonLabel.text = "\(shopLemons)"
		shopIceLabel.text = "\(shopIce)"
		mixLemonLabel.text = "\(mixLemons)"
		mixIceLabel.text = "\(mixIce)"
	}

	func showAlertWithText(header: String = "Warning", message: String) {
		var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}

	func simulateWeatherToday() {
		let index = Int(rand()) % weatherArray.count
		weatherToday = weatherArray[index]

		switch index {
		case 0: weatherImageView.image = UIImage(named: "coldWeather")
		case 1: weatherImageView.image = UIImage(named: "mildWeather")
		case 2: weatherImageView.image = UIImage(named: "warmWeather")
		default: weatherImageView.image = UIImage(named: "warmWeather")
		}
	}

	func findAverage(data: [Int]) -> Int {
		var sum = 0

		for x in data {
			sum += x
		}

		var average = Double(sum) / Double(data.count)
		return Int(ceil(average))
	}
}

