//
//  TokenRequestViewController.swift
//  kushki-ios_Example
//
//  Created by Bryan Lema on 9/10/19.
//  Copyright © 2019 Kushki. All rights reserved.
//

import UIKit
import Kushki
import WebKit
class TokenRequestViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var ResponseView: UITextView!
    @IBOutlet weak var RequestToken: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expiryMonth: UITextField!
    @IBOutlet weak var expiryYear: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var webView: WKWebView!
    
    var transaction: Transaction? = nil
    var message: String = ""
    var kushki = Kushki(publicMerchantId: "1bf6da01f11d46f8bc059aed82eaca1f",
                        currency: "MXN",
                        environment: KushkiEnvironment.testing)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView!.navigationDelegate = self
    }
  
    @IBAction func clicked(_ sender: Any) {
        let card = Card(name: nameField.text!,number: cardNumber.text!, cvv: cvv.text!,expiryMonth: expiryMonth.text!,expiryYear: expiryYear.text!)
        requestKushkiToken(card: card, totalAmount: totalAmount.text!, isTest:true )
        return
    }

    private func requestKushkiToken(card: Card, totalAmount: String, isTest: Bool) {
        self.kushki.requestToken(card: card, totalAmount: Double(totalAmount) ?? 0.0, isTest: isTest) { transaction in
            self.transaction = transaction
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
            let secureId = transaction.secureId != nil ? transaction.secureId! : ""
            let acsURL = transaction.security!.acsURL != nil ? transaction.security!.acsURL! : ""
            if(transaction.security!.acsURL != nil && transaction.secureId != nil && transaction.security!.specificationVersion!.starts(with: "1.")){
                self.loadWeb(payload: transaction.security!.paReq!, acsUrl: transaction.security!.acsURL!)
            }
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token request",
                                              message: message,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: {(alert: UIAlertAction!) in self.secureValidation()}))
                self.present(alert, animated: true)
                var msgTotal: String = "Token response: \n\n" + message
                if (secureId != "") {
                    msgTotal.append("\nSecureId: " + secureId)
                }
                if (acsURL != "") {
                    msgTotal.append("\nAcsUrl: " + acsURL)
                }
                self.ResponseView.text = msgTotal
            })
        }
    }
    
    
    private func loadWeb(payload: String,acsUrl:String){
             
            let termUrl = "https://m.youtube.com" //TERM_URL_VALUE_HERE
             
            var components = URLComponents(string: acsUrl)!
            components.queryItems = [URLQueryItem(name: "PaReq", value: payload), URLQueryItem(name: "TermUrl", value: termUrl), URLQueryItem(name: "MD", value: "123456")]
             
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
             
            let url = components.url!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = ["Content-Type":"x-www-form-urlencoded"]
             
            DispatchQueue.main.async {
                self.webView!.load(request)
            }
            
        }
    
    func secureValidation(){
        if(self.transaction!.security!.acsURL != nil && self.transaction!.secureId != nil && self.transaction!.security!.specificationVersion!.starts(with: "2.")){
            self.kushki.requestSecureValidation(secureServiceId: self.transaction!.secureId!, otpValue: ""){secureValidation in
                print(secureValidation)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Kushki Request Validation",
                                                  message: secureValidation.message,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("intercept")
        print(navigationAction.request)
        if let url = navigationAction.request.url?.absoluteString {
            if (url.contains("https://m.youtube.com")) {
                if(url == "https://m.youtube.com/") {
                    if(self.transaction != nil){
                        self.kushki.requestSecureValidation(secureServiceId: self.transaction!.secureId!, otpValue: ""){secureValidation in
                            print(secureValidation)
                        }
                        self.kushki.requestSecureValidation(secureServiceId: self.transaction!.secureId!, otpValue: ""){secureValidation in
                            print(secureValidation)
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Kushki Request Validation",
                                                              message: secureValidation.message,
                                                              preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                                self.present(alert, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
        decisionHandler(.allow)
    }
}

