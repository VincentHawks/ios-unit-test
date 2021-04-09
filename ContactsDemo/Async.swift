//
//  Async.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import Foundation

public func asyncMain(execute work: @escaping () -> Void) {
    DispatchQueue.main.async(execute: work)
}

public func async(execute work: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async(execute: work)
}
