//
//  AlertManager.swift
//  iPartnerJuniorTestTask
//
//  Created by Valentin Kiselev on 29.09.2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

class AlertManager {
	
	static func showWarning(title: String, message: String? = nil) {
		let ac = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
		let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
		ac.addAction(ok)
		UIApplication.topViewController()?.present(ac, animated: false, completion: nil)
	}
		
	static func showWarningWithAction(title: String, message: String? = nil, completionBlock:@escaping (_ okPressed:Bool)->()) {
		let ac = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
		let ok = UIAlertAction(title: "Reload data", style: .default) { (ok) in
			completionBlock(true)
		}
		ac.addAction(ok)
		UIApplication.topViewController()?.present(ac, animated: false, completion: nil)
	}
}

extension UIApplication {
	static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
		if let navigationController = base as? UINavigationController {
			return topViewController(base: navigationController.visibleViewController)
		}
		if let presented = base?.presentedViewController {
			return topViewController(base: presented)
		}
		return base
	}
}
