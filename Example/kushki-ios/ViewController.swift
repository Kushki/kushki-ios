import UIKit
import Kushki
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet weak var getSubscriptionTransferButton: UIButton!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var IdentificationDocument: UITextField!
    @IBOutlet weak var docTypePicker: UIPickerView!
    @IBOutlet weak var bankPicker: UIPickerView!
    @IBOutlet weak var Email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: Actions
    @IBAction func handleTouchUpInside(_ sender: UIButton) {
    
    }
    
    @IBAction func handleOpenCardTokenView() {
        let view = CardTokenView()
        let hostingController = UIHostingController(rootView: view)
        present(hostingController, animated: true)
    }
    
   

    
    
    
    
}
