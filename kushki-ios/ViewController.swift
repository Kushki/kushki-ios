import UIKit

class ViewController: UIViewController {

    static let message = "Eum ipsum eum minima non quasi quos ut aut. Praesentium sint nisi illo et est id reprehenderit. Harum ducimus aperiam ut quod numquam. Ut ipsam nulla ratione."

    // MARK: Properties
    @IBOutlet weak var doItButton: UIButton!
    @IBOutlet weak var doItHttpButton: UIButton!
    @IBOutlet weak var outputTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Actions
    @IBAction func setOutputText(_ sender: UIButton) {
        let aurusEnc = AurusEncryption()
        outputTextView.text = aurusEnc.encrypt(ViewController.message)
    }

    @IBAction func showHttpResponse(_ sender: UIButton) {
        let publicMerchantId = "10000001641125237535111218"
        let totalAmount = 10.00
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        kushki.requestToken(card: card, totalAmount: totalAmount) { transaction in
            DispatchQueue.main.async(execute: {
                let transactionCode = transaction.code
                let transactionSuccessful = transaction.isSucessful().description
                let transactionToken = transaction.token
                let transactionText = transaction.text
                self.outputTextView.text = transactionCode + "\n" + transactionSuccessful + "\n" + transactionToken + "\n" + transactionText
            })
        }
    }
}
