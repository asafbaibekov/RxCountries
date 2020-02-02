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

	init(title: String, subtitle: String?) {
		self.title = title
		self.subtitle = subtitle
	}
}
