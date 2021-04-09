//
//  NewContactViewController.swift
//  ContactsDemo
//
//  Created by Artem Goncharov on 29.03.2021.
//

import UIKit

class NewContactViewController: UIViewController {

    @IBOutlet private var firstNameField: UITextField!
    @IBOutlet private var lastNameField: UITextField!
    @IBOutlet private var phoneField: UITextField!
    
    var onResult: ((ContactsData) -> Void)?
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        onResult?(ContactsData(firstName: firstNameField.text ?? "", lastName: lastNameField.text ?? "", phone: phoneField.text ?? ""))
        navigationController?.popViewController(animated: true)
    }
}
