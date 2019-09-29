//
//  FullRecordViewController.swift
//  iPartnerJuniorTestTask
//
//  Created by Valentin Kiselev on 27.09.2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

class FullRecordViewController: UIViewController {
	
	@IBOutlet weak var recordBobyTextView: UITextView!
	
	var record: UserRecord!

    override func viewDidLoad() {
        super.viewDidLoad()
		recordBobyTextView.text = record.body
		navigationBarSetup()
    }
	
	private func navigationBarSetup() {
		let backButtonTitle = "Back"
		let backItem = UIBarButtonItem()
		backItem.title = backButtonTitle
		navigationItem.backBarButtonItem = backItem

	}
    

}
