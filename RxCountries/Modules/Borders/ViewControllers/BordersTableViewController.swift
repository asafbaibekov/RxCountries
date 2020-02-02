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
import RxDataSources

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
		let dataSource = RxTableViewSectionedReloadDataSource<SectionBorders>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
			let cell: UITableViewCell = {
				if let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") { return cell }
				return UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
			}()
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.text = item.title
			cell.detailTextLabel?.text = item.subtitle
			return cell
		}, titleForHeaderInSection: { dataSource, index in
			dataSource.sectionModels[index].header
		})
		output.borders
			.drive(tableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}

}
