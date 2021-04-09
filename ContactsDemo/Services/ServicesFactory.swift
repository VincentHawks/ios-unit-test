//
//  ServicesFactory.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import Foundation

protocol ServicesFactory {
    func getContactsRepository() -> ContactsRepository
    func getCallHistoryRepository() -> CallHistoryRepository
}

enum Services {
    static var factory: ServicesFactory!
}
