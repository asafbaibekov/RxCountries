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
		return Output(
			fetching: self.loading.asDriver(),
			error: self.error.asDriver { _ in .empty() },
			title: self.title.asDriver { _ in .empty() },
			countries: Driver.merge(countries, filteredCountries)
		)
	}
}
