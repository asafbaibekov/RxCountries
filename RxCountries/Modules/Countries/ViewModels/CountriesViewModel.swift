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
	}
	struct Output {
		let fetching: Driver<Bool>
		let error: Driver<Error>
		let title: Driver<String>
		let countries: Driver<[CountryItemViewModel]>
	}

	private let countries: BehaviorRelay<[CountryItemViewModel]>
	private let loading: BehaviorRelay<Bool>
	private let error: PublishSubject<Error>
	private var title: Observable<String> { .just("Countries") }

	init() {
		countries = BehaviorRelay<[CountryItemViewModel]>(value: [CountryItemViewModel]())
		loading = BehaviorRelay<Bool>(value: false)
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
		let filteredCountries = input.search.map { string -> [CountryItemViewModel] in
			guard let string = string, !string.isEmpty else { return self.countries.value }
			return self.countries.value.filter { $0.country.name.lowercased().starts(with: string.lowercased()) }
		}
		let countries_final = Driver.combineLatest(input.orderBy, Driver.merge(countries, filteredCountries))
			.map { (int, viewModels) -> [CountryItemViewModel] in
				switch int {
				case 0: return viewModels.sorted(by: { $0.country.name < $1.country.name })
				case 1: return viewModels.sorted(by: { $0.country.name > $1.country.name })
				case 2: return viewModels.sorted(by: { $0.country.area ?? 0 < $1.country.area ?? 0 })
				case 3: return viewModels.sorted(by: { $0.country.area ?? 0 > $1.country.area ?? 0 })
				default: return viewModels
				}
			}
		return Output(
			fetching: self.loading.asDriver(),
			error: self.error.asDriver { _ in .empty() },
			title: self.title.asDriver { _ in .empty() },
			countries: countries_final
		)
	}
}
