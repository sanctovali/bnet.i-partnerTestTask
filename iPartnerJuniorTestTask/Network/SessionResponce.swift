//
//  Responce.swift
//  iPartnerJuniorTestTask
//
//  Created by Valentin Kiselev on 28.09.2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import Foundation

struct SessionResponce: Codable {
	let status: Int
	let data: DataStruct?
	let error: String?
	init(data: Data) throws {
		self = try JSONDecoder().decode(SessionResponce.self, from: data)
	}

	struct DataStruct: Codable {
		let session: String
	}
}

struct AddEntryResponce: Codable {
	let status: Int
	let data: DataStruct?
	let error: String?
	init(data: Data) throws {
		self = try JSONDecoder().decode(AddEntryResponce.self, from: data)
	}
	
	struct DataStruct: Codable {
		let id: String
	}
}

struct EntriesResponse: Codable {
	let status: Int
	let data: [[UserRecord]]?
	let error: String?
	init(data: Data) throws {
		self = try JSONDecoder().decode(EntriesResponse.self, from: data)
	}

}



