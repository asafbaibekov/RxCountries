//
//  CountryItemViewModel.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 31/01/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import Foundation

class CountryItemViewModel {

	let country: Country
	let title: String?
	let subtitle: String?

	init(_ country: Country) {
		self.country = country

		let name = country.name
		let nativeName = country.nativeName
		self.title = name == nativeName ? name : "\(name)\n\(nativeName)"

		self.subtitle = {
			guard let area = country.area else { return nil }
			let formatter = NumberFormatter()
			formatter.maximumFractionDigits = 2
			return "area: \(formatter.string(from: NSNumber(floatLiteral: area))!)"
		}()
	}

}
