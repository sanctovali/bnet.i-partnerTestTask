//
//  ViewController.swift
//  iPartnerJuniorTestTask
//
//  Created by Valentin Kiselev on 27.09.2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

class UserRecordsViewController: UIViewController {
	@IBOutlet weak var userRecordsTableView: UITableView!
	private var records = [UserRecord]()
	private var isInternetAvailable = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupNavigationController()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super .viewWillAppear(animated)
		if !NetworkConnection.isConnected {
			AlertManager.showWarningWithAction(title: "Check the internet connection") { (_) in
				UserRecordsNetworkService.getEntries(completion: { [weak self] (response) in
					if response.status == 0 {
						AlertManager.showWarning(title: "Error", message: response.error!)
					} else {
						self?.userRecordsTableView.reloadData()
					}
				})
			}
		} else {
			UserRecordsNetworkService.getEntries() { [weak self] (response) in
				guard let records = response.data?.first else { return }
				self?.records = records
				self?.userRecordsTableView.reloadData()
			}
			
		}
	}
	
	private func setupTableView() {
		userRecordsTableView.delegate = self
		userRecordsTableView.dataSource = self
		userRecordsTableView.register(UINib.init(nibName: "userRecordTableViewCell", bundle: nil), forCellReuseIdentifier: userRecordTableViewCell.cellIdentifier)
		userRecordsTableView.showsVerticalScrollIndicator = false
		userRecordsTableView.rowHeight = UITableView.automaticDimension
		userRecordsTableView.estimatedRowHeight = 200
	}
	
	private func setupNavigationController() {
		let backButtonTitle = "Back"
		let backItem = UIBarButtonItem()
		backItem.title = backButtonTitle
		navigationItem.backBarButtonItem = backItem
	}
}
//MARK: UITableViewDelegate methods

extension UserRecordsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "showDetail", sender: indexPath)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
			guard let dvc = segue.destination as? FullRecordViewController else {
				print("Error in \(#file) at line \(#line) in function \(#function)")
				fatalError("Error: Unrecognized viewController")
			}
			let indexPath = sender as! IndexPath
			let row = indexPath.row
			dvc.record = records[row]
			userRecordsTableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
}

//MARK: UITableViewDataSource methods
extension UserRecordsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return records.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: userRecordTableViewCell.cellIdentifier, for: indexPath) as? userRecordTableViewCell else {
			let cell = userRecordTableViewCell(style: .default, reuseIdentifier: userRecordTableViewCell.cellIdentifier)
			return cell
		}
		let record = records[indexPath.row]
		cell.configure(with: record)
		
		return cell
	}
	
	
}
