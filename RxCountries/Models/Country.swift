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

extension Country {
	static func getCountries() -> Observable<[Country]> {
		let url = URL(string: "https://restcountries.eu/rest/v2/all")!
		let res = Resource<[Country]>(url: url)
		return URLRequest
			.load(resource: res)
			.observeOn(MainScheduler.instance)
	}
}
