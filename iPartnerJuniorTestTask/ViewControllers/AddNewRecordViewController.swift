//
//  AddNewRecordViewController.swift
//  iPartnerJuniorTestTask
//
//  Created by Valentin Kiselev on 27.09.2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

class AddNewRecordViewController: UIViewController {

	@IBOutlet weak var newRecordTextView: UITextView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	
	var sessionId: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		newRecordTextView.delegate = self
		let hideKbGesture = UITapGestureRecognizer(target: self, action: #selector(hideKb))
		self.view.addGestureRecognizer(hideKbGesture)
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		registerNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeNotifications()
	}
	
	private func setupUI() {
		
		let cancelButtonTitle = "Cancel"
		let saveButtonTitle = "Save"
		saveButton.isEnabled = false
		cancelButton.setTitle(cancelButtonTitle, for: [])
		saveButton.setTitle(saveButtonTitle, for: [])
	}
	
	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let newRecord = newRecordTextView.text else { return }
		UserRecordsNetworkService.addEntry(newRecord) { [weak self] (response) in
			if response.status == 1 {
				self?.dismiss(animated: true, completion: nil)
			} else {
				AlertManager.showWarning(title: "Error", message: response.error!)
			}
		}
	}

	@IBAction func cancelButtonTapped(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

}

//keyboard handling
extension AddNewRecordViewController {
	//клава вверх
	@objc func kbWillShow(notification: Notification) {
		let userInfo = notification.userInfo! as NSDictionary
		let kbSize = (userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
		let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
		
		self.newRecordTextView?.contentInset = contentInsets
	}
	//клава вниз
	@objc func kbwillHide(notification: Notification) {
		let contentInsets = UIEdgeInsets.zero
		newRecordTextView?.contentInset = contentInsets
	}
	
	//прячем клаву по тапу на вью
	@objc func hideKb() {
		self.newRecordTextView.endEditing(true)
	}
	
	//подписываемся на уведомления
	func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.kbWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.kbwillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	//отписываемся от уведомлений
	func removeNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
}

extension AddNewRecordViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		if textView == self.newRecordTextView {
			self.saveButton.isEnabled = !textView.text.isEmpty
		}
	}
}
