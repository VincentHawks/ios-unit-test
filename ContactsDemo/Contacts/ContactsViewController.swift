//
//  ContactsViewController.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import UIKit

class ContactsViewController: UIViewController {
    
    private enum Identifiers {
        static let contactCell = "contactCell"
        static let addNewContact = "addNewContact"
    }

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var contactsTableView: UITableView!
    
    private var output: ContactsViewOutput!
    private var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = ContactsPresenter(contactsRepository: Services.factory.getContactsRepository(), callHistoryRepository: Services.factory.getCallHistoryRepository())
        presenter.view = self
        output = presenter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewOpened()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Identifiers.addNewContact:
            guard let addNewContact = segue.destination as? NewContactViewController else { return }
            
            addNewContact.onResult = { [weak self] contact in
                self?.output.newContactAdded(contact)
            }
        default:
            break
        }
    }
}

extension ContactsViewController: ContactsView {
    func showProgress() {
        contactsTableView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func hideProgress() {
        activityIndicator.stopAnimating()
        contactsTableView.isHidden = false
    }
    
    
    func showContacts(_ contacts: [Contact]) {
        self.contacts = contacts
        contactsTableView.reloadData()
    }
    
    func showError(_ error: Error) {
        
    }
}


extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.contactCell, for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = "\(contact.firstName) \(contact.lastName)"
        cell.detailTextLabel?.text = contact.phone
        
        return cell
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = contacts[indexPath.row]
        output.contactPressed(contact)
    }
}
