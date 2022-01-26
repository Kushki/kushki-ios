//
//  OTPSandboxViewController.swift
//  Kushki
//
//  Created by Adrian Calvopina on 1/12/21.
//

import UIKit

class OTPSandboxViewController: UIViewController {

    private var phoneNumber: String = "5329"
    private var merchantName: String = "Kushki Merchant"
    private var currency: String = "USD"
    private var amount: String = "200.00"
    private var cardNumber: String = "1091"
    private let otpValue: String = "1234"
    
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak private var merchantNameLabel: UILabel!
    @IBOutlet weak private var cardNumberLabel: UILabel!
    @IBOutlet weak private var OTPLabel: UILabel!
    @IBOutlet weak private var submitButton: UIButton!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak private var OTPtextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }

    public func initValues(merchantName:String,currency:String,amount:Double,cardNumber:String){
        self.merchantName = merchantName
        self.currency = currency
        self.amount = String(format: "%.2f", amount)
        self.cardNumber = String(cardNumber.suffix(4))
    }
    
    private func initView(){
        self.messageLabel.text = self.messageLabel.text?.replacingOccurrences(of: "{NUMBER}", with: phoneNumber)
        self.merchantNameLabel.text = self.merchantNameLabel.text?.replacingOccurrences(of: "{MERCHANT_NAME}", with: merchantName)
        self.amountLabel.text = self.amountLabel.text?.replacingOccurrences(of: "{CURRENCY}", with: currency)
        self.amountLabel.text = self.amountLabel.text?.replacingOccurrences(of: "{AMOUNT}", with: amount)
        self.cardNumberLabel.text = self.cardNumberLabel.text?.replacingOccurrences(of: "{CARD_NUMBER}", with: cardNumber)
        self.OTPLabel.text = self.OTPLabel.text?.replacingOccurrences(of: "{OTP}", with: otpValue)
        self.OTPtextfield.layer.borderWidth = 1
        self.OTPtextfield.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func onChangeOTP(_ sender: Any) {
        self.submitButton.isEnabled = !self.OTPtextfield.text!.isEmpty
    }
    @IBAction func clickCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickSubmit(_ sender: Any) {
        if((self.OTPtextfield.text!.compare(otpValue).rawValue) == 0){
            self.dismiss(animated: true)
        } else {
            self.OTPtextfield.text = ""
            self.submitButton.isEnabled = false
        }
    }
}
