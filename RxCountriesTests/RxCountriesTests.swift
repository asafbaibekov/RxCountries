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
	func getCountries() -> Observable<[Country]> { .just([]) }
}
