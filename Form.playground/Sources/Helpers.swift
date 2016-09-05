import UIKit

extension UIViewController {
    public func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(closeAction)
        present(alertController, animated: true)
    }
}

