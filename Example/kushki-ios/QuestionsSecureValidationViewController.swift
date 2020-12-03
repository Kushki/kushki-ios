//
//  QuestionsSecureValidationViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 9/11/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class QuestionsSecureValidationViewController: UIViewController {

    @IBOutlet weak var secureServiceIdField: UITextField!
    @IBOutlet weak var secureServiceField: UITextField!
    @IBOutlet weak var cityCodeField: UITextField!
    @IBOutlet weak var stateCodeField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var expeditionDateField: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    var kushkiTransfer : Kushki?
    let publicTransferMerchantId: String? = "a499dddde82b433f832f26f685cbe468"
    override func viewDidLoad() {
        super.viewDidLoad()
        kushkiTransfer  = Kushki(publicMerchantId: self.publicTransferMerchantId!,
                                 currency: "COP",
                                 environment: KushkiEnvironment.testing)
    }
    @IBAction func handleTouchUpInside(_ sender: Any) {
        kushkiTransfer!.requestSecureValidation(cityCode: cityCodeField.text!, expeditionDate: expeditionDateField.text!, phone: phoneField.text!, secureService: secureServiceField.text!, secureServiceId: secureServiceIdField.text!, stateCode: stateCodeField.text!){questionnarie in
            let message = questionnarie.isSuccessful() ?
                questionnarie.questionnarieCode : questionnarie.code + ": " + questionnarie.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                self.ResponseView.text = "Response questions subscription transfer token: \n\n" + message
            })
        }
    }
}
