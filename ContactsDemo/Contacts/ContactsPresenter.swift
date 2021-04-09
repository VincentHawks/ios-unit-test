//
//  ContactsPresenter.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import Foundation

class ContactsPresenter {
    
    private var contactsRepository: ContactsRepository!
    private var callHistoryRepository: CallHistoryRepository!
    weak var view: ContactsView?

    init(contactsRepository: ContactsRepository, callHistoryRepository: CallHistoryRepository) {
        self.contactsRepository = contactsRepository
        self.callHistoryRepository = callHistoryRepository
    }
}

extension ContactsPresenter: ContactsViewOutput {
    func viewOpened() {
        view?.showProgress()
        async { [weak self] in
            
            guard let self = self else {
                return
            }
            
            defer {
                asyncMain {
                    self.view?.hideProgress()
                }
            }
            
            do {
                let contacts = try self.contactsRepository.getContacts()
                asyncMain {
                    self.view?.showContacts(contacts)
                }
            } catch {
                asyncMain {
                    self.view?.showError(error)
                }
            }
        }
    }
    
    func contactPressed(_ contact: Contact) {
        makeCall(to: contact)
    }
    
    func makeCall(to contact: Contact) {
        
        do {
            try callHistoryRepository.add(record: CallRecord(timestamp: Date(),
                                                             phone: contact.phone))
        } catch {
            view?.showError(error)
        }
    }
    
    func newContactAdded(_ contact: ContactsData) {
        do {
            try contactsRepository.add(contact: contact)
        } catch {
            view?.showError(error)
        }
    }
    
}
