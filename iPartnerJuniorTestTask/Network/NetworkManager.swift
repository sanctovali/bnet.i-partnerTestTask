//
//  NetworkManager.swift
//  iPartnerJuniorTestTask
//
//  Created by Valentin Kiselev on 27.09.2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//
//
import Foundation

class NetworkService {
	
	static let shared = NetworkService()
	private init() {}
	
	func fetchData(request: URLRequest, completion: @escaping (Data?) -> Void) {
		let session = URLSession.shared
		session.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				print("error!: \(String(describing: error?.localizedDescription))")
				return
			}
			
			guard let response = response as? HTTPURLResponse,
				response.statusCode < 300 &&
					response.statusCode > 99 else {
						AlertManager.showWarning(title: "Error", message: error?.localizedDescription)
						print("error!: \(String(describing: error?.localizedDescription))")
						return
			}
//			print("statuscode:", response.statusCode)
			
			guard let data = data else {
				AlertManager.showWarning(title: "Error", message: error?.localizedDescription)
				print("Error in \(#function) at line \(#line): can't fetch data")
				completion(nil)
				return
			}
			DispatchQueue.main.async {
				completion(data)
			}
			
			}.resume()
	}
}
