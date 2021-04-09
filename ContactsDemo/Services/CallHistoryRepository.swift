//
//  CallHistoryRepository.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import Foundation

struct CallRecord {
    let timestamp: Date
    let phone: String
}

protocol CallHistoryRepository {
    
    func getHistory() throws -> [CallRecord]
    func add(record: CallRecord) throws
}
