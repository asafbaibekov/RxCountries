//
//  RxCountriesTests.swift
//  RxCountriesTests
//
//  Created by Asaf Baibekov on 25/02/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import RxCountries

class RxCountriesTests: XCTestCase {

	var viewModel: CountriesViewModel!
	var scheduler: TestScheduler!
	var disposeBag: DisposeBag!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()
		viewModel = CountriesViewModel(countryService: self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		viewModel = nil
		scheduler = nil
		disposeBag = nil
    }

	func testOrderByCountries() {
		let countries = scheduler.createObserver([Country].self)
		let orderBySubject = PublishSubject<Int>()

		let input = CountriesViewModel.Input(
			triggle: .just(()),
			search: .just(""),
			orderBy: orderBySubject.asObservable(),
			selection: .empty()
		)
		let output = viewModel.transform(input: input)
		
		output.countries
			.map { $0.map { $0.country } }
			.drive(countries)
			.disposed(by: disposeBag)
		
		scheduler.createColdObservable([
			.next(0, 0),
			.next(10, 1),
			.next(20, 2),
			.next(30, 3)
		])
		.bind(to: orderBySubject)
		.disposed(by: disposeBag)
		
		scheduler.start()
		
		XCTAssertEqual(countries.events, [
			.next(0, [
				franceCountry,
				israelCountry,
				spainCountry
			]),
			.next(10, [
				spainCountry,
				israelCountry,
				franceCountry
			]),
			.next(20, [
				israelCountry,
				spainCountry,
				franceCountry
			]),
			.next(30, [
				franceCountry,
				spainCountry,
				israelCountry
			])
		])
	}
}

extension RxCountriesTests: CountryService {
	func getCountries() -> Observable<[Country]> { .just([spainCountry, israelCountry, franceCountry]) }
}

private extension RxCountriesTests {
	var franceCountry: Country {
		Country(name: "France", nativeName: "France", alpha3Code: "FRA", borders: ["AND", "BEL", "DEU", "ITA", "LUX", "MCO", "ESP", "CHE"], area: 640679)
	}
	var spainCountry: Country {
		Country(name: "Spain", nativeName: "España", alpha3Code: "ESP", borders: ["AND", "FRA", "GIB", "PRT", "MAR"], area: 505992)
	}
	var israelCountry: Country {
		Country(name: "Israel", nativeName: "יִשְׂרָאֵל", alpha3Code: "ISR", borders: ["EGY", "JOR", "LBN", "SYR"], area: 20770)
	}
}
