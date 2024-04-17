import SwiftNotify
import UIKit

class ExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showCyberView() {
        SN.show(title: "Hello World", message: "Welcome to Swift World!!", level: .success)
    }
}
