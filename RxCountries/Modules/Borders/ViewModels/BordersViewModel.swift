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

	private let country: Country
	private let borderedCountries: [Country]

	init(country: Country, borderedCountries: [Country]) {
		self.country = country
		self.borderedCountries = borderedCountries
	}

	func transform(input: Input) -> Output {
		return Output(
			title: Driver.just(country).map { $0.name },
			countries: Driver.just(borderedCountries).map { $0.map(CountryItemViewModel.init) }
		)
	}
}
