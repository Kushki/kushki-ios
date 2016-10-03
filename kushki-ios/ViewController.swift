import UIKit

class ViewController: UIViewController {

    static let message = "Eum ipsum eum minima non quasi quos ut aut. Praesentium sint nisi illo et est id reprehenderit. Harum ducimus aperiam ut quod numquam. Ut ipsam nulla ratione."

    // MARK: Properties
    @IBOutlet weak var doItButton: UIButton!
    @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func setOutputText(_ sender: UIButton) {
        let aurusEnc = AurusEncryption()
        let encryptedMessage = aurusEnc.encryptMessageChunk(requestMessage: ViewController.message)
        outputTextView.text = encryptedMessage
    }
}
