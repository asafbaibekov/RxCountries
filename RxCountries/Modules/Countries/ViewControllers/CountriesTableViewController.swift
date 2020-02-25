//
//  CountriesTableViewController.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 27/01/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CountriesTableViewController: UITableViewController {

	let disposeBag = DisposeBag()

	lazy var viewModel = CountriesViewModel(countryService: self)

	lazy var searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.scopeButtonTitles = ["Name ASC", "Name DESC", "Area ASC", "Area DESC"]
		searchController.searchBar.placeholder = "Search Country"
		searchController.searchBar.showsScopeBar = true
		return searchController
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		setupView()
		setupRx()
	}

	func setupView() {
		self.tableView.refreshControl = UIRefreshControl()
		self.tableView.delegate = nil
		self.tableView.dataSource = nil
		self.definesPresentationContext = true
		self.clearsSelectionOnViewWillAppear = true
		self.navigationItem.hidesSearchBarWhenScrolling = false
		self.navigationItem.searchController = searchController
	}

	func setupRx() {
		let input = CountriesViewModel.Input(
			triggle: .merge(
				rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map({ _ in }),
				tableView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()
			),
			search: searchController.searchBar.rx.text.orEmpty.asObservable(),
			orderBy: searchController.searchBar.rx.selectedScopeButtonIndex.asObservable(),
			selection: tableView.rx.itemSelected.asObservable()
		)

		let output = viewModel.transform(input: input)

		output.title
			.drive(navigationItem.rx.title)
			.disposed(by: disposeBag)

		output.countries
			.drive(tableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self), curriedArgument: { tv, viewModel, cell in
				cell.textLabel?.numberOfLines = 0
				cell.textLabel?.text = viewModel.title
				cell.detailTextLabel?.text = viewModel.subtitle
			})
			.disposed(by: disposeBag)

		output.fetching
			.drive(tableView.refreshControl!.rx.isRefreshing)
			.disposed(by: disposeBag)

		output.error
			.drive(onNext: { [weak self] error in
				let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default))
				self?.present(alert, animated: true)
			})
			.disposed(by: disposeBag)

		output.selectedCountry
			.drive(onNext: { [weak self] bordersViewModel in
				guard let self = self else { return }
				let bordersTVC = BordersTableViewController(style: .plain)
				bordersTVC.viewModel = bordersViewModel
				self.navigationController?.pushViewController(bordersTVC, animated: true)
			})
			.disposed(by: disposeBag)
	}

}

extension CountriesTableViewController: CountryService {
	func getCountries() -> Observable<[Country]> {
		let url = URL(string: "https://restcountries.eu/rest/v2/all")!
		let res = Resource<[Country]>(url: url)
		return URLRequest
			.load(resource: res)
			.observeOn(MainScheduler.instance)
	}
}
