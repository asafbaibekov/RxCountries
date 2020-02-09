//
//  CountriesViewModel.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 30/01/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CountriesViewModel {

	struct Input {
		let triggle: Driver<Void>
		let search: Driver<String?>
		let orderBy: Driver<Int>
		let selection: Driver<IndexPath>
	}
	struct Output {
		let fetching: Driver<Bool>
		let error: Driver<Error>
		let title: Driver<String>
		let countries: Driver<[CountryItemViewModel]>
		let selectedCountry: Driver<BordersViewModel>
	}

	private let countries: BehaviorRelay<[CountryItemViewModel]>
	private let loading: BehaviorRelay<Bool>
	private let search: BehaviorRelay<String>
	private let error: PublishSubject<Error>
	private var title: Observable<String> { .just("Countries") }

	init() {
		countries = BehaviorRelay<[CountryItemViewModel]>(value: [CountryItemViewModel]())
		loading = BehaviorRelay<Bool>(value: false)
		search = BehaviorRelay<String>(value: "")
		error = PublishSubject<Error>()
	}

	func transform(input: Input) -> Output {
		let countries = input.triggle.flatMapLatest { [weak self] _ in
			return Country.getCountries()
				.asDriver { [weak self] error in
					self?.loading.accept(false)
					self?.error.onNext(error)
					return .empty()
				}
				.do(onCompleted: { self?.loading.accept(false) })
				.map { $0.map(CountryItemViewModel.init) }
				.do(onNext: self?.countries.accept)
		}

		let countries_final = Driver.combineLatest(
			input.orderBy,
			input.search.map { $0 ?? "" },
			countries
		)
			.map { (int, string, viewModels) -> [CountryItemViewModel] in
				let viewModels = viewModels.filter { $0.country.name.lowercased().starts(with: string.lowercased()) }
				switch int {
				case 0: return viewModels.sorted(by: { $0.country.name < $1.country.name })
				case 1: return viewModels.sorted(by: { $0.country.name > $1.country.name })
				case 2: return viewModels.sorted(by: { $0.country.area ?? 0 < $1.country.area ?? 0 })
				case 3: return viewModels.sorted(by: { $0.country.area ?? 0 > $1.country.area ?? 0 })
				default: return viewModels
				}
			}

		let selectedCountry = input.selection.withLatestFrom(countries_final) { indexPath, viewModels -> BordersViewModel in
			let country = viewModels[indexPath.row].country
			let borderedCountries = country.borders.map { border in
				self.countries.value.map { $0.country }.first { border == $0.alpha3Code }!
			}
			return BordersViewModel(country: country, borderedCountries: borderedCountries)
		}

		return Output(
			fetching: self.loading.asDriver(),
			error: self.error.asDriver { _ in .empty() },
			title: self.title.asDriver { _ in .empty() },
			countries: countries_final,
			selectedCountry: selectedCountry
		)
	}
}
