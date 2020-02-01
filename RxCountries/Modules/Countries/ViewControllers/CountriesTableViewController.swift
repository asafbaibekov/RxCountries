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

	let viewModel = CountriesViewModel()

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
	}

	func setupRx() {
		let input = CountriesViewModel.Input(
			triggle: Driver.merge(
				rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
					.map({ _ in })
					.asDriver(onErrorJustReturn: ()),
				tableView.refreshControl!.rx
					.controlEvent(.valueChanged)
					.asDriver()
			)
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
	}

}
