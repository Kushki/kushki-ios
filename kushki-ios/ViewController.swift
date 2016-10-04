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
        let url = URL(string: "https://uat.aurusinc.com/kushki/api/v1/tokens")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "{\"test\": 1}".data(using: String.Encoding.utf8)
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask (with: request) { data, response, error in
            if let theError = error {
                print(theError.localizedDescription)
                return
            }
            let httpResponse = response as! HTTPURLResponse
            let responseBody = String(data: data!, encoding: String.Encoding.utf8)!
            let outputString = String(format: "%d\n%@", httpResponse.statusCode, responseBody)
            DispatchQueue.main.async(execute: {
                self.outputTextView.text = outputString
            })
        }
        task.resume()
    }
}
