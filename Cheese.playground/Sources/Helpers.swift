import UIKit

public enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Collection {
    public var randomElement: Iterator.Element {
        let distance = self.distance(from: self.startIndex, to: self.endIndex)
        let randomDistance = arc4random_uniform(numericCast(distance))
        let randomIndex = self.index(self.startIndex, offsetBy: numericCast(randomDistance))
        return self[randomIndex]
    }
}

extension Bool {
    public static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}

extension UIViewController {
    public func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(closeAction)
        present(alertController, animated: true)
    }
}

extension Notification.Name {
    public static let modelDidChange = NSNotification.Name("ModelDidChange")
}
