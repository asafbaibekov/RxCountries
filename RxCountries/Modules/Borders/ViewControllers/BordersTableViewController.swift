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
		
	}

}
