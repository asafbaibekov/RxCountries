//
//  BorderItemViewModel.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 02/02/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import Foundation
import RxDataSources

class BorderItemViewModel {

	let title: String
	let subtitle: String?

	init(title: String, area: Double?) {
		self.title = title
		self.subtitle = {
			guard let area = area else { return nil }
			let formatter = NumberFormatter()
			formatter.maximumFractionDigits = 2
			return "area: \(formatter.string(from: NSNumber(floatLiteral: area))!)"
		}()
	}
}
