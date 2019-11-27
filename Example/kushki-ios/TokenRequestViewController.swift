//
//  TokenRequestViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 9/10/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki
class TokenRequestViewController: UIViewController {
    @IBOutlet weak var ResponseView: UITextView!
    @IBOutlet weak var RequestToken: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expiryMonth: UITextField!
    @IBOutlet weak var expiryYear: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var totalAmount: UITextField!
    var message: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
  
    @IBAction func clicked(_ sender: Any) {
        let card = Card(name: nameField.text!,number: cardNumber.text!, cvv: cvv.text!,expiryMonth: expiryMonth.text!,expiryYear: expiryYear.text!)
        requestKushkiToken(card: card, totalAmount: totalAmount.text! )
        return
    }
    
    private func requestKushkiToken(card: Card, totalAmount: String) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        kushki.requestToken(card: card, totalAmount: Double(totalAmount) ?? 0.0) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            //                transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token request",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
            self.ResponseView.text = "Token response: \n\n" + message
        }
    }
}

