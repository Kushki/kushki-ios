//
//  CardAsyncTokenRequestViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 10/8/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class SubscriptionCardAsyncTokenRequestViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var callbackUrlField: UITextField!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleTouchUpInside(_ sender: Any) {
        requestKushkiToken(email: emailField.text!, callbackUrl: callbackUrlField.text!, cardNumber: cardNumberField.text!)
        return
    }
    private func requestKushkiToken(email : String, callbackUrl: String, cardNumber: String) {
        let publicMerchantId = "12410184888150783738635"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing)
        kushki.requestSubscriptionCardAsyncToken(email: email, callbackUrl: callbackUrl, cardNumber: cardNumber){
            transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Subscription Card Async Token request",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                self.ResponseView.text = "Token response: \n\n" + message
            })
        }
    }
}
