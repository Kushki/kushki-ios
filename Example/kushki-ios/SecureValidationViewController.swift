//
//  SecureValidationViewController.swift
//  kushki-ios_Example
//
//  Created by Marco Moreno on 26/11/20.
//  Copyright © 2020 Kushki. All rights reserved.
//

import UIKit
import Kushki

class SecureValidationViewController: UIViewController {
    @IBOutlet weak var secureServiceId: UITextField!
    @IBOutlet weak var optValue: UITextField!
    @IBOutlet weak var secureService: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clicked(_ sender: Any) {
        let secureValidation = SecureValidation(secureServiceId: secureServiceId.text!, otpValue: optValue.text!, secureService: secureService.text!)
        requestSecureValidation(secureValidation: secureValidation)
        return
    }
    
    private func requestSecureValidation(secureValidation: SecureValidation) {
        let publicMerchantId = "20000000108588217776"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing_qa)
        print("secureService: " + secureValidation.secureService!)
        if (secureValidation.secureService != "") {
            kushki.requestSecureValidation(secureServiceId: secureValidation.secureServiceId, otpValue: secureValidation.otpValue, secureService: secureValidation.secureService!){
                response in
                let message = response.isSuccessful() ? "code: " + response.code + " message: " + response.message : "error: " + response.message
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "Kushki secure validation card: " + publicMerchantId,
                                                  message: message,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                    self.ResponseView.text = "Message: \n\n" + message
                })
            }
        } else {
            kushki.requestSecureValidation(secureServiceId: secureValidation.secureServiceId, otpValue: secureValidation.otpValue){
                response in
                let message = response.isSuccessful() ? "code: " + response.code + " message: " + response.message : "error: " + response.message
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "Kushki secure validation card: " + publicMerchantId,
                                                  message: message,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                    self.ResponseView.text = "Message: \n\n" + message
                })
            }
        }
    }
}
