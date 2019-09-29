//
//  UserRecordsNetworkService.swift
//  iPartnerJuniorTestTask
//
//  Created by Valentin Kiselev on 28.09.2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import Foundation

enum APIMethod: String {
	case new_session
	case get_entries
	case add_entry
}

class UserRecordsNetworkService {
	private init() {}
	
	private static var sessionId: String {
		if let session = UserDefaults.standard.string(forKey: "sessionId") {
			return session
		} else {
			UserRecordsNetworkService.getSessionId { (response)  in
				if response.status == 1 {
					UserDefaults.standard.set(response.data?.session, forKey: "sessionId")
				} else {
					AlertManager.showWarning(title: "Error", message: response.error!)
				}
			}
		}
		return UserDefaults.standard.string(forKey: "sessionId") ?? ""
	}
	private static let token : [String: String] = ["token" : "AiUenBV-5v-5psQL3j"]
	
	
	private static func makeRequest(parameters: [String: String]) -> URLRequest {
		let resourceString = "https://bnet.i-partner.ru/testAPI/"
		guard let url = URL(string: resourceString) else {
			fatalError("Error in \(#function) at line \(#line): can't create URL")
		}
		var request = URLRequest(url: url)
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.setValue(self.token.values.first!, forHTTPHeaderField: self.token.keys.first!)
		request.httpMethod = "POST"
		let parametersString = parameters.map { (key, value) -> String in
			return key + "=" + value
		}.joined(separator: "&")
		request.httpBody = parametersString.data(using: .utf8)

		return request
	}
	
	static func getSessionId(completion: @escaping(SessionResponce)-> Void) {
		
		let request = makeRequest(parameters: ["a": APIMethod.new_session.rawValue])
		
		NetworkService.shared.fetchData(request: request) { (data) in
			guard let data = data else { return }
			do {
				let response = try SessionResponce(data: data)
				completion(response)
			} catch {
				AlertManager.showWarning(title: "Error", message: error.localizedDescription)
				print("Error in \(#function) at line \(#line): \(error.localizedDescription)")
			}
		}
	}
	
	static func addEntry(_ entry: String, completion: @escaping(AddEntryResponce)-> Void) {
		
		let request = makeRequest(parameters: ["a": APIMethod.add_entry.rawValue, "session": sessionId, "body": entry])
		
		NetworkService.shared.fetchData(request: request) { (data) in
			guard let data = data else { return }
			do {
				let response = try AddEntryResponce(data: data)
				completion(response)
			} catch {
				AlertManager.showWarning(title: "Error", message: error.localizedDescription)
				print("Error in \(#function) at line \(#line): \(error.localizedDescription)")
			}
		}
	}
	
	static func getEntries(completion: @escaping(EntriesResponse)-> Void) {
		
		let request = makeRequest(parameters: ["a": APIMethod.get_entries.rawValue, "session": sessionId])
		
		NetworkService.shared.fetchData(request: request) { (data) in
			guard let data = data else { return }
			do {
				let response = try EntriesResponse(data: data)
				completion(response)
			} catch {
				AlertManager.showWarning(title: "Error", message: error.localizedDescription)
				print("Error in \(#function) at line \(#line): \(error.localizedDescription)")
			}
		}
	}
	
}
