//
//  userRecordTableViewCell.swift
//  iPartnerJuniorTestTask
//
//  Created by Valentin Kiselev on 27.09.2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

class userRecordTableViewCell: UITableViewCell {

	@IBOutlet weak var daLabelStatic: UILabel!
	@IBOutlet weak var daLabelDynamic: UILabel!
	@IBOutlet weak var dmLabelStatic: UILabel!
	@IBOutlet weak var dmLabelDynamic: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!
	
	
	static let cellIdentifier = "recordCell"
	
	func configure(with record: UserRecord) {
		let maxPreviewLenght = 200
		let text = String(record.body.prefix(maxPreviewLenght))
		bodyLabel.text = text
		let daText = "Created:"
		daLabelStatic.text = daText
		var date = Date(timeIntervalSince1970: TimeInterval(Int(record.da)!))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yy"
		daLabelDynamic.text = dateFormatter.string(from: date)
		
		if record.da != record.dm {
			let dmText = "Modified:"
			dmLabelStatic.text = dmText
			date = Date(timeIntervalSince1970: TimeInterval(Int(record.dm)!))
			dmLabelDynamic.text = dateFormatter.string(from: date)
			dmLabelStatic.isHidden = false
			dmLabelDynamic.isHidden = false
		}
		
	}
    
}
