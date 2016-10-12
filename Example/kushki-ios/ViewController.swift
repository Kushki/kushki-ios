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
        requestKushkiToken(card: card)
    }

    private func requestKushkiToken(card: Card) {
        let publicMerchantId = "10000001641125237535111218"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        kushki.requestToken(card: card, totalAmount: 19.99) { transaction in
            let message = transaction.isSuccessful() ?
                transaction.token :
                transaction.code + ": " + transaction.text
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
