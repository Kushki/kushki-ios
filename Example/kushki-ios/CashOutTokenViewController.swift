//
//  CashOutTokenViewController.swift
//  kushki-ios_Example
//
//  Created by Alexandra Hurtado on 12/5/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki

class CashOutTokenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var detail: UITextField!
    @IBOutlet weak var documentNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var documentType: UIPickerView!
    
    @IBOutlet weak var ResponseView: UITextView!
    let pickerData = [DocumentType.CC, DocumentType.CE,DocumentType.NIT,DocumentType.PP]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentType.delegate = self
        documentType.dataSource = self
        // Do any additional setup after loading the view.
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }


    @IBAction func handleTouchUpInside(_ sender: Any) {
        let data = CashOutToken(documentNumber: documentNumber.text!, name: name.text!, lastName: lastName.text!, totalAmount: Double(totalAmount.text!) ?? 0.0, documentType:pickerData[documentType.selectedRow(inComponent: 0)], currency: "", description: detail.text!, email:email.text!)
        requestCashOutToken(data:data)
        return
    }
    
    private func requestCashOutToken(data:CashOutToken){
        let publicMerchantId = "20000000107321580000"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "COP",
                            environment: KushkiEnvironment.testing_ci)
        
        kushki.requestCashOutToken(data: data){
          transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
               
                self.ResponseView.text = "Token response: \n\n" + message
            })
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
