//
//  GetCardInfoViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 10/8/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class GetCardInfoViewController: UIViewController {

    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleTouchUpInside(_ sender: Any) {
        requestCardInfo(cardNumber: cardNumberField.text!)
        return
    }
    
    private func requestCardInfo(cardNumber: String) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        kushki.getCardInfo(cardNumber: cardNumber){ cardInfo in
            let message = "\nBank: "+cardInfo.bank + "\nBrand: " + cardInfo.brand + "\nCard type: " + cardInfo.cardType
            DispatchQueue.main.sync(execute: {
                let alert = UIAlertController(title: "Get Card Info response",
                                              message: message,
                                        preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                self.ResponseView.text = "Get card info response: \n\n" + message
            })
        }
    }
    
}
