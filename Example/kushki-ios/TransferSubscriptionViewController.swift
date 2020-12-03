//
//  TransferSubscriptionViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 9/11/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki
class TransferSubscriptionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var documentTypePicker: UIPickerView!
    @IBOutlet weak var documentNumberField: UITextField!
    @IBOutlet weak var accountNumberField: UITextField!
    @IBOutlet weak var accountTypeField: UITextField!
    @IBOutlet weak var ResponseView: UITextView!
    
    @IBOutlet weak var bankListPicker: UIPickerView!
    @IBOutlet weak var amountField: UITextField!
    let publicTransferMerchantId: String? = "a499dddde82b433f832f26f685cbe468"
    var kushkiTransfer : Kushki?
    var banks: [Bank] = [Bank(code: "", name: "")]
    let documentTypes: [String] = ["CC","CI"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bankListPicker.delegate = self
        bankListPicker.dataSource = self
        documentTypePicker.delegate = self
        documentTypePicker.dataSource = self
        kushkiTransfer  = Kushki(publicMerchantId: self.publicTransferMerchantId!,
                                 currency: "COP",
                                 environment: KushkiEnvironment.testing)
        kushkiTransfer!.getBankList(){
            returnedBankList in
            self.banks = returnedBankList
            DispatchQueue.main.async(execute: {
                self.bankListPicker.reloadAllComponents()
            })
        }
    }
    
    @IBAction func handleTouchUpInside(_ sender: Any) {
        kushkiTransfer!.requestTransferSubscriptionToken(accountNumber: accountNumberField.text!, accountType: accountTypeField.text!, bankCode: banks[bankListPicker.selectedRow(inComponent: 0)].code, documentNumber: documentNumberField.text!, documentType: documentTypes[documentTypePicker.selectedRow(inComponent: 0)], email: emailField.text!, lastname: lastNameField.text!, name: nameField.text!, totalAmount: Double(amountField.text!) ?? 0.0){
            transaction in
            let response = "token: \(transaction.token) \nsecureId: \(transaction.secureId ?? "") \nsecureService: \(transaction.secureService ?? "")"
            let message = transaction.isSuccessful() ?
                response : transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                self.ResponseView.text = "Response subscription transfer token: \n\n" + message
            })
        }
        return
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == documentTypePicker){
            return documentTypes.count
        }
        else if(pickerView == bankListPicker){
            return banks.count
        }
        else{
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == documentTypePicker){
            return documentTypes[row]
        }
        else if(pickerView == bankListPicker){
            return banks[row].name
        }
        else{
            return ""
        }
        
    }
    private func requestSubscriptionTransferToken(accountNumber: String, accountType: String, bankCode: String, documentNumber: String, documentType: String, email: String, lastname: String, name: String,totalAmount: Double) {
        
        kushkiTransfer!.requestTransferSubscriptionToken(
            accountNumber: accountNumber,
            accountType: accountType,
            bankCode: bankCode,
            documentNumber: documentNumber,
            documentType: documentType,
            email: email,
            lastname: lastname,
            name: name,
            totalAmount: totalAmount) { transaction in
                let message = transaction.isSuccessful() ?
                    transaction.token : transaction.code + ": " + transaction.message
                //                transaction.code + ": " + transaction.message
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "Kushki Transfer Subscription",
                                                  message: message,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                })
        }
    }
}
