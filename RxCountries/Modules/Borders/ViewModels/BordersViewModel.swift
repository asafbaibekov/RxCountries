//
//  BordersViewModel.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 01/02/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BordersViewModel {
	struct Input {

	}
	struct Output {
		let title: Driver<String>
		let countries: Driver<[CountryItemViewModel]>
	}

	let country: Driver<Country>
	let borderedCountries: Driver<[Country]>

	init(country: Country, borderedCountries: [Country]) {
		self.country = .just(country)
		self.borderedCountries = .just(borderedCountries)
	}

	func transform(input: Input) -> Output {
		return Output(
			title: country.map { $0.name },
			countries: borderedCountries.map { $0.map( CountryItemViewModel.init) }
		)
	}
}
