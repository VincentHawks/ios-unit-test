//
//  ContactsPresenterTests.swift
//  ContactsDemoTests
//
//  Created by Artem Goncharov on 07.04.2021.
//

import XCTest
@testable import ContactsDemo

class MockView : ContactsView {
    func showContacts(_ contacts: [Contact]) {
        print(#function)
    }
    
    func showError(_ error: Error) {
        print(#function)
    }
    
    func showProgress() {
        print(#function)
    }
    
    func hideProgress() {
        print(#function)
    }
}

class TestError : Error {}

class MockThrowingContactsRepository : ContactsRepository {
    func getContacts() throws -> [Contact] {
        throw TestError()
    }
    
    func add(contact: ContactsData) throws {
        throw TestError()
    }
    
    func update(contact: Contact) throws {
        throw TestError()
    }
    
    func delete(contact: Contact) throws {
        throw TestError()
    }
}

class MockContactsRepository : ContactsRepository {
    func getContacts() throws -> [Contact] {
        return []
    }
    
    func add(contact: ContactsData) throws {
        
    }
    
    func update(contact: Contact) throws {
        
    }
    
    func delete(contact: Contact) throws {
        
    }
}

class MockThrowingCallHistoryRepository : CallHistoryRepository {
    func getHistory() throws -> [CallRecord] {
        throw TestError()
    }
    
    func add(record: CallRecord) throws {
        throw TestError()
    }
}

class MockCallHistoryrepository : CallHistoryRepository {
    func getHistory() throws -> [CallRecord] {
        return []
    }
    
    func add(record: CallRecord) throws {
        
    }
}

class ContactsPresenterTests: XCTestCase {
    
    var presenter: ContactsPresenter!
    
    override func setUp() {
        presenter = ContactsPresenter(contactsRepository: MockContactsRepository(), callHistoryRepository: MockCallHistoryrepository())
        let view = MockView()
        presenter.view = view
    }
    
    func testInstantiatedCorrectly() {
        XCTAssertNotNil(presenter.self, "Failed to instantiate presenter")
    }
    
    func testViewOpenedNoViewPassed() {
        presenter.view = nil
        XCTAssertNoThrow(presenter.viewOpened(), "Failed to handle no view passed")
    }
    
    func testViewOpenedViewPassed() {
        XCTAssertNoThrow(presenter.viewOpened(), "Failed to proceed normally")
    }
    
    func testViewOpenedViewDeallocated() {
        class DisappearingView : ContactsView {
            
            var presenterReference: ContactsPresenter!
            
            func showContacts(_ contacts: [Contact]) {
                
            }
            
            func showError(_ error: Error) {
                
            }
            
            func showProgress() {
                presenterReference.view = nil
            }
            
            func hideProgress() {
                
            }
        }
        
        let view = DisappearingView()
        view.presenterReference = presenter
        presenter.view = view
        
        XCTAssertNoThrow(presenter.viewOpened(), "Failed to handle view closing")
    }
    
    func testViewOpenedPresenterKilled() {
        
        class MockSignallingView : ContactsView {
            
            var completed = false
            
            func showContacts(_ contacts: [Contact]) {
                
            }
            
            func showError(_ error: Error) {
                
            }
            
            func showProgress() {
                
            }
            
            func hideProgress() {
                completed = true
            }
        }
        let view = MockSignallingView()
        presenter.view = view
        XCTAssertNoThrow(presenter.viewOpened(), "Failed to handle presenter death")
        presenter = nil
        XCTAssertFalse(view.completed, "Failed to kill presenter")
    }
    
    func testViewOpenedFaultyContactsRepository() {
        let view = MockView()
        presenter = ContactsPresenter(contactsRepository: MockThrowingContactsRepository(), callHistoryRepository: MockCallHistoryrepository())
        presenter.view = view
        
        XCTAssertNoThrow(presenter.viewOpened(), "Failed to handle error in repository")
    }
    
    func testContactPressed() {
        let contact = Contact(recordId: "", firstName: "Mock", lastName: "Contact", phone: "+00000000000")
        XCTAssertNoThrow(presenter.contactPressed(contact), "Failed to make a call properly")
    }
    
    func testContactPressedFaultyCallHistoryRepository() {
        let view = MockView()
        presenter = ContactsPresenter(contactsRepository: MockContactsRepository(), callHistoryRepository: MockThrowingCallHistoryRepository())
        presenter.view = view
        let contact = Contact(recordId: "", firstName: "Mock", lastName: "Contact", phone: "+00000000000")
        XCTAssertNoThrow(presenter.contactPressed(contact), "Failed to handle error while making a call")
    }
    
    func testNewContactAdded() {
        let contact = ContactsData(firstName: "Mock", lastName: "Contact", phone: "+00000000000")
        XCTAssertNoThrow(presenter.newContactAdded(contact), "Failed to add new contact")
    }
    

    func testNewContactAddedFaultyContactsRepository() {
        presenter = ContactsPresenter(contactsRepository: MockThrowingContactsRepository(), callHistoryRepository: MockCallHistoryrepository())
        let view = MockView()
        presenter.view = view
        
        let contact = ContactsData(firstName: "Mock", lastName: "Contact", phone: "+00000000000")
        
        XCTAssertNoThrow(presenter.newContactAdded(contact), "Failed to handle error in repository")
        
    }
}
