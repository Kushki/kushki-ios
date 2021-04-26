//
//  SubscriptionTokenViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 9/10/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class SubscriptionTokenViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var expiryMonthField: UITextField!
    @IBOutlet weak var expiryYearField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    
    @IBOutlet weak var AmountField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleClick(_ sender: Any) {
        let card = Card(name: nameField.text!,number: cardNumberField.text!, cvv: cvvField.text!,expiryMonth: expiryMonthField.text!,expiryYear: expiryYearField.text!)
        let isTest = true
        requestKushkiSubscriptionToken(card: card, isTest: isTest )
        return
    }
    
    private func requestKushkiSubscriptionToken(card: Card, isTest: Bool) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        
        kushki.requestSubscriptionToken(card: card, isTest: isTest) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token Subscription", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
            self.ResponseView.text = "Token subscription response\n\n" + message
            }
        
        }
}

