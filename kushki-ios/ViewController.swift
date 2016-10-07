import UIKit

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

    @IBAction func requestToken(_ sender: UIButton) {
        let publicMerchantId = "10000001641125237535111218"
        let card = Card(name: nameField.text!, number: numberField.text!, cvv: cvvField.text!, expiryMonth: monthField.text!, expiryYear: yearField.text!)
        let totalAmount = 10.00
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        kushki.requestToken(card: card, totalAmount: totalAmount) { transaction in
            print(transaction.token)
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Aurus Token",
                                              message: transaction.token,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            })
        }
    }

}
