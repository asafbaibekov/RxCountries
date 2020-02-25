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
