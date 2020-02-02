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
		let borders: Driver<[SectionBorders]>
	}

	private let country: Country
	private let borderedCountries: [Country]

	init(country: Country, borderedCountries: [Country]) {
		self.country = country
		self.borderedCountries = borderedCountries
	}

	func transform(input: Input) -> Output {
		let title: Driver<String> = Driver.just(country).map { $0.name }
		let borders = Driver.just(borderedCountries)
			.map { countries -> [SectionBorders] in
				let names = countries.map { country in
					BorderItemViewModel(
						title: country.name,
						subtitle: {
							guard let area = country.area else { return nil }
							let formatter = NumberFormatter()
							formatter.maximumFractionDigits = 2
							return "area: \(formatter.string(from: NSNumber(floatLiteral: area))!)"
						}()
					)
				}
				let nativeNames = countries.map { country in
					BorderItemViewModel(
						title: country.nativeName,
						subtitle: {
							guard let area = country.area else { return nil }
							let formatter = NumberFormatter()
							formatter.maximumFractionDigits = 2
							return "area: \(formatter.string(from: NSNumber(floatLiteral: area))!)"
						}()
					)
				}
				var sections = [SectionBorders]()
				if !names.isEmpty { sections.append(SectionBorders(header: "Names", items: names)) }
				if !nativeNames.isEmpty { sections.append(SectionBorders(header: "Native names", items: nativeNames)) }
				return sections
			}
		return Output(
			title: title,
			borders: borders
		)
	}
}
