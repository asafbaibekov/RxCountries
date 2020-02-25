//
//  Country.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 27/01/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Country: Decodable {
	let name: String
	let nativeName: String
	let alpha3Code: String
	let borders: [String]
	let area: Double?
}

protocol CountryService {
	func getCountries() -> Observable<[Country]>
}
