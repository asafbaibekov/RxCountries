//
//  SectionBorders.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 02/02/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionBorders {
	var header: String
	var items: [Item]
}

extension SectionBorders: SectionModelType {
	typealias Item = BorderItemViewModel

	init(original: SectionBorders, items: [Item]) {
		self = original
		self.items = items
	}
}
