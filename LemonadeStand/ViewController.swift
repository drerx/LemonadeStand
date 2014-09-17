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

	var mixratio: Double = 0
	var weathers:[Weather] = [] // I realize this isn't english and nope, not gonna change it.

	override func viewDidLoad() {
		super.viewDidLoad()

		// Initialize Weather
		var coldWeather = Weather()
		coldWeather.customerBonus = -3
		coldWeather.image = UIImage(named: "coldWeather")
		var mildWeather = Weather()
		mildWeather.customerBonus = 0
		mildWeather.image = UIImage(named: "mildWeather")
		var warmWeather = Weather()
		warmWeather.customerBonus = 4
		warmWeather.image = UIImage(named: "warmWeather")
		weathers += [coldWeather, mildWeather, warmWeather]

		updateView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func buyLemonsButton(sender: UIButton) {
		if supplies.money >= 2 {
			supplies.money -= 2
			supplies.lemons++
			shopLemons++
		} else {
			showAlertWithText(header: "You're broke!", message: "You can't afford a lemon.")
		}
		updateView()
	}
	@IBAction func sellLemonsButton(sender: UIButton) {
		if supplies.lemons > 0 {
			supplies.lemons--
			shopLemons--
			supplies.money += 2
		} else {
			showAlertWithText(header: "No lemons, dude.", message: "You can't sell a lemon you don't have.")
		}
		updateView()
	}

	@IBAction func buyIceButton(sender: UIButton) {
		if supplies.money >= 1 {
			supplies.money--
			supplies.iceCubes++
			shopIce++
		} else {
			showAlertWithText(header: "You're broke!", message: "You can't even afford an ice cube. Sucks for you, man.")
		}
		updateView()
	}
	@IBAction func sellIceButton(sender: UIButton) {
		if supplies.iceCubes > 0 {
			supplies.iceCubes--
			shopIce--
			supplies.money++
		} else {
			showAlertWithText(header: "Nah, man.", message: "How you gonna sell ice if you don't have no ice?")
		}
		updateView()
	}

	@IBAction func addLemonsButton(sender: UIButton) {
		if supplies.lemons > 0 {
			supplies.lemons--
			shopLemons--
			mixLemons++
		}
		updateView()
	}
	@IBAction func removeLemonsButton(sender: UIButton) {
		if mixLemons > 0 {
			mixLemons--
			supplies.lemons++
			shopLemons++
		}
		updateView()
	}

	@IBAction func addIceButton(sender: UIButton) {
		if supplies.iceCubes > 0 {
			supplies.iceCubes--
			shopIce--
			mixIce++
		}
		updateView()
	}
	@IBAction func removeIceButton(sender: UIButton) {
		if mixIce > 0 {
			mixIce--
			supplies.iceCubes++
			shopIce++
		}
		updateView()
	}

	@IBAction func startDayButton(sender: UIButton) {
		if mixLemons > 0 && mixIce > 0 {
			// Choose a random weather for the day
			let randomWeatherIndex = Int(arc4random_uniform(UInt32(3)))
			let randomWeather = weathers[randomWeatherIndex]
			weatherImageView.hidden = false
			weatherImageView.image = randomWeather.image

			// Calculate the mixratio
			mixratio = Double(mixLemons) / Double(mixIce)

			// Theoretically one should make a limited amount of lemonade, not just a ratio.
			// But I'm leaving that out for this game.

			// Generate random customers and let them buy lemonade according to their preference
			var moneyEarned = 0
			var numberOfCustomers = Int(arc4random_uniform(UInt32(10))) + randomWeather.customerBonus
			while numberOfCustomers < 2 || numberOfCustomers > 10 {
				numberOfCustomers = Int(arc4random_uniform(UInt32(10))) + randomWeather.customerBonus
			}
			for i in 0...numberOfCustomers {
				let customerPreference: Double = Double(arc4random_uniform(UInt32(10))) / 10
				// Check the customer preference
				if abs(customerPreference - mixratio) < 0.3 { // Customer loved it.
					moneyEarned += 2
				} else if abs(customerPreference - mixratio) < 0.6 {
					moneyEarned += 1
				} else { // Hated it, wanted his/her money back!
					moneyEarned += 0
				}
			}

			// Reset the mix.
			mixLemons = 0
			mixIce = 0

			// Give the player the money and display how much the player earned today.
			supplies.money += moneyEarned
			customerSatisfactionLabel.hidden = false
			customerSatisfactionLabel.text = "You made $\(moneyEarned) today with \(numberOfCustomers) happy customers!"
			moneyEarned = 0

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
}

