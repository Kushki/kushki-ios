//
//  CardAsyncTokenRequestViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 10/8/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class CardAsyncTokenRequestViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var totalAmountField: UITextField!
    @IBOutlet weak var returnUrlField: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleTouchUpInside(_ sender: Any) {
        requestKushkiToken(email: emailField.text!, description: descriptionField.text!, totalAmount: totalAmountField.text!, returnUrl: returnUrlField.text!)
        return
        
    }
    
    private func requestKushkiToken(email : String, description: String, totalAmount: String, returnUrl: String) {
        let publicMerchantId = "20000000106145247000"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing_qa)
        kushki.requestCardAsyncToken(description: description, email: email, returnUrl: returnUrl, totalAmount: Double(totalAmount) ?? 0.00){ transaction in
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
