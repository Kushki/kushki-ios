//
//  AnswersSecureValidationViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 9/12/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class AnswersSecureValidationViewController: UIViewController {

    @IBOutlet weak var secureServiceIdField: UITextField!
    @IBOutlet weak var secureServiceField: UITextField!
    @IBOutlet weak var questionnarieCodeField: UITextField!
    @IBOutlet weak var answer1Field: UITextField!
    @IBOutlet weak var answer2Field: UITextField!
    @IBOutlet weak var answer3Field: UITextField!
    var kushkiTransfer : Kushki?
    @IBOutlet weak var ResponseView: UITextView!
    let publicTransferMerchantId: String? = "a499dddde82b433f832f26f685cbe468"
    override func viewDidLoad() {
        super.viewDidLoad()
        kushkiTransfer  = Kushki(publicMerchantId: self.publicTransferMerchantId!,
                                 currency: "COP",
                                 environment: KushkiEnvironment.testing)
    }
    @IBAction func handleTouchUpInside(_ sender: Any) {
        let answers : [[String: String]] = [
            [
                "id": "id",
                "answer": answer1Field.text!],
            [
                "id": "id",
                "answer": answer2Field.text!
            ],
            [
                "id": "id",
                "answer": answer3Field.text!
            ]
        ]
        kushkiTransfer!.requestSecureValidation(answers: answers, questionnarieCode: questionnarieCodeField.text!, secureService: secureServiceField.text!, secureServiceId: secureServiceIdField.text!){
            responseObject in
            let message = responseObject.isSuccessful() ?
                responseObject.message : responseObject.code + ": " + responseObject.message
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
