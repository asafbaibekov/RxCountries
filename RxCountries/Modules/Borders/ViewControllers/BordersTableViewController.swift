//
//  BordersTableViewController.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 01/02/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BordersTableViewController: UITableViewController {

	var disposeBag = DisposeBag()

	var viewModel: BordersViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupRx()
	}

	func setupView() {
		self.tableView.delegate = nil
		self.tableView.dataSource = nil
	}

	func setupRx() {
		let input = BordersViewModel.Input()
		let output = viewModel.transform(input: input)
		output.title
			.drive(navigationItem.rx.title)
			.disposed(by: disposeBag)
		output.countries
			.asObservable()
			.bind(to: tableView.rx.items) { tableView, row, viewModel in
				let cell: UITableViewCell = {
					if let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") { return cell }
					return UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
				}()
				cell.textLabel?.numberOfLines = 0
				cell.textLabel?.text = viewModel.title
				cell.detailTextLabel?.text = viewModel.subtitle
				return cell
			}
			.disposed(by: disposeBag)
	}

}
