import UIKit
import Kushki

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var doItHttpButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var cvvField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Actions
    @IBAction func handleTouchUpInside(_ sender: UIButton) {
        let card = Card(name: nameField.text!,
                        number: numberField.text!,
                        cvv: cvvField.text!,
                        expiryMonth: monthField.text!,
                        expiryYear: yearField.text!)
        if(sender.titleLabel?.text == "Request Subscription"){
            requestKushkiToken(card: card, subscription: true)
            return
        }
        requestKushkiToken(card: card)
    }

    private func requestKushkiToken(card: Card, subscription: Bool = false) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        if(subscription){
            kushki.requestSubscriptionToken(card: card) { transaction in
                let message = transaction.isSuccessful() ?
                    transaction.token : transaction.code + ": " + transaction.message
//                    transaction.code + ": " + transaction.message
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "Kushki Token",
                                                  message: message,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                })
            }
            return
        }
        kushki.requestToken(card: card, totalAmount: 19.99) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token : transaction.code + ": " + transaction.message
//                transaction.code + ": " + transaction.message
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Kushki Token",
                                              message: message,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
        }
    }
}
