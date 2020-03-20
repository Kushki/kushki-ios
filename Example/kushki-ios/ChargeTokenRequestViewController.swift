//
//  ChargeTokenRequestViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 11/28/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class ChargeTokenRequestViewController: UIViewController {
    @IBOutlet weak var publicMerchantId: UITextField!
    @IBOutlet weak var subscriptionId: UITextField!
    @IBOutlet weak var tokenButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var currencyCode: UITextField!
    @IBOutlet weak var environment: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func handleTouchUpInside(_ sender: Any) {
        if(environment.text! == "UAT"){
            requestChargeTokenSubscription(publicMerchantId: publicMerchantId.text!, subscriptionId: subscriptionId.text!, currencyCode: currencyCode.text!, environment: KushkiEnvironment.testing)
        } else if(environment.text! == "PROD"){
            requestChargeTokenSubscription(publicMerchantId: publicMerchantId.text!, subscriptionId: subscriptionId.text!, currencyCode: currencyCode.text!, environment: KushkiEnvironment.production)
        }
        else{
            let message = "Environment: " + environment.text! + " not available"
            DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Error",
                                          message: message,
                                    preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Error", style: .default))
            })
        }
        
        return
    }
    private func requestChargeTokenSubscription(publicMerchantId: String, subscriptionId: String, currencyCode: String, environment: KushkiEnvironment) {
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: currencyCode,
                            environment: KushkiEnvironment.testing)
        kushki.requestSubscriptionChargeToken(subscriptionId: subscriptionId){ transaction in
            let message = "\nToken: " + transaction.token + "\nMessage: " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Get charge token info response",
                                              message: message,
                                        preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                self.textView.text = "Get charge token info response: \n\n" + message
            })
            
        }
    }
    
    
    
}
