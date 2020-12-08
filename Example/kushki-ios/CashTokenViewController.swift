//
//  CashTokenViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 9/24/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class CashTokenViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var identificationField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func handleTouchUpInside(_ sender: Any) {
        requestKushkiToken(name: nameField.text!, lastName: lastNameField.text!, identification: identificationField.text!, totalAmount: amountField.text!, email: emailField.text!)
        return
        
    }
    private func requestKushkiToken(name : String, lastName: String, identification: String, totalAmount: String, email: String) {
        let publicMerchantId = "6000000000154083361249085016881"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "COP",
                            environment: KushkiEnvironment.testing)
        kushki.requestCashToken(name: name, lastName: lastName, identification: identification, totalAmount: Double(totalAmount) ?? 0.0, email: email) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            //                transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token request",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                self.ResponseView.text = "Token response: \n\n" + message
            })
        }
    }

}
