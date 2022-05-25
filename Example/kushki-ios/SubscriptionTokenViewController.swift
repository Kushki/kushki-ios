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
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var validationButton: UIButton!
    
    var idSecure:String = ""
    var serviceSecure:String = ""
    
    
    @IBOutlet weak var AmountField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        otpField.isHidden = true
        validationButton.isHidden = true
    }
    
    @IBAction func handleClick(_ sender: Any) {
        let card = Card(name: nameField.text!,number: cardNumberField.text!, cvv: cvvField.text!,expiryMonth: expiryMonthField.text!,expiryYear: expiryYearField.text!)
        let isTest = true
        requestKushkiSubscriptionToken(card: card, isTest: isTest )
        return
    }
    
    @IBAction func verificationOTP(_ sender: Any) {
        requestKushkiValidationOTP()
        
    }
    private func requestKushkiValidationOTP(){
        let publicMerchantId = "cd7167989ce84000881de34b135e4b16"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing_qa)
        
        kushki.requestSecureValidation(secureServiceId: idSecure, otpValue: otpField.text!, secureService: serviceSecure){response in
            
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Validation Response", message: response.message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
        }
        
    }
    private func requestKushkiSubscriptionToken(card: Card, isTest: Bool) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        
        kushki.requestSubscriptionToken(card: card, isTest: isTest) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            
            if(transaction.secureService!=="KushkiOTP"){
                self.otpField.isHidden = false
                self.validationButton.isHidden = false
            }
            
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token Subscription", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
            self.ResponseView.text = "Token subscription response:\n" + message+"\n"+"SecureId:\n"+transaction.secureId!+"\n"+"Secure Service:\n"+transaction.secureService!
            
            self.serviceSecure = transaction.secureService!
            self.idSecure = transaction.secureId!
            
            }
        
        }
}

