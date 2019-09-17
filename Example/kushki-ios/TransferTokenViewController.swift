//
//  TransferTokenViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 9/11/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki
class TransferTokenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var userType: UISegmentedControl!
    @IBOutlet weak var documentType: UIPickerView!
    @IBOutlet weak var documentNumber: UITextField!
    @IBOutlet weak var callBackUrl: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var transferDescription: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    let pickerData = [ "CC" , "NIT" , "CE" , "TI" , "PP" , "RUT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentType.delegate = self
        documentType.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerData[row]
    }
    
    func mapUserType(userType:String) -> String {
        if(userType == "Natural")
        {return "0"}
        else
        {return "1"}
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBAction func handleClick(_ sender: Any) {
        let amount = Amount(subtotalIva: Double(self.amount.text!) ?? 0.0 , subtotalIva0: 0.0, iva: Double(self.amount.text!) ?? 0.0)
        requestKushkiTransferToken(amount: amount, callbackUrl: callBackUrl.text!, userType: mapUserType(userType: userType.titleForSegment(at: userType.selectedSegmentIndex)!), documentType: pickerData[documentType.selectedRow(inComponent: 0)], documentNumber: documentNumber.text!, email: email.text!, description: transferDescription.text!)
    }
    
    private func requestKushkiTransferToken(amount: Amount, callbackUrl:String, userType:String, documentType:String, documentNumber:String, email:String, description:String) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing)
        
        kushki.requestTransferToken(amount: amount, callbackUrl: callbackUrl, userType: userType, documentType: documentType, documentNumber: documentNumber, email: email,paymentDescription: description) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            //                transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
            self.ResponseView.text = "Response transfer token: \n\n" + message
        }
    }
}
