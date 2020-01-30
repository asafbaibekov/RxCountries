//
//  CountriesTableViewController.swift
//  RxCountries
//
//  Created by Asaf Baibekov on 27/01/2020.
//  Copyright © 2020 Asaf Baibekov. All rights reserved.
//

import UIKit

class CountriesTableViewController: UITableViewController {

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
		
	}

}
