//
//  GistContactsRepo.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import Foundation

class GistContactsRepo: ContactsRepository {
    
    private let url: URL
    private let decoder: JSONDecoder
    
    private var contacts: [Contact] = []
    
    init(url: URL) {
        self.url = url
        decoder = JSONDecoder()
    }
    
    func getContacts() throws -> [Contact] {
        
        guard contacts.isEmpty else {
            return contacts
        }
        
        let sem = DispatchSemaphore(value: 0)
        let request = URLRequest(url: url)
        
        var resultError: Error? = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer {
                sem.signal()
            }
            
            guard error == nil else {
                resultError = error
                return
            }
            
            guard let data = data else {
                return
            }
            
            struct ContactsResponse: Decodable {
                let firstname: String
                let lastname: String
                let phone: String
                let email: String
            }
            
            do {
                self.contacts = try self.decoder.decode([ContactsResponse].self, from: data).map {
                    Contact(recordId: UUID().uuidString,
                            firstName: $0.firstname,
                            lastName: $0.lastname,
                            phone: $0.phone)
                }
                
            } catch {
                resultError = error
            }
        }
        task.resume()
        // TODO: add timeout
        sem.wait()
        
        
        if let error = resultError {
            throw error
        }
        
        return contacts
    }
    
    func add(contact: ContactsData) throws {
        fatalError("unimplemented")
    }
    
    func delete(contact: Contact) throws {
        fatalError("unimplemented")
    }
    
    func update(contact: Contact) throws {
        fatalError("unimplemented")
    }
}
