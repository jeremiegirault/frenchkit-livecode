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

extension String {
    var cheeseImage: UIImage? {
        return UIImage(imageLiteralResourceName: "\(self).jpg")
    }
    
    var cheeseImageData: Data? {
        let url = Bundle.main.url(forResource: self, withExtension: "jpg")
        return url.flatMap { try? Data(contentsOf: $0) }
    }
}

public extension UIViewController {
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(closeAction)
        present(alertController, animated: true)
    }
    
    func setLoading(_ loading: Bool, animated: Bool) {
        if loading && presentedViewController == nil {
            let loading = LoaderViewController()
            loading.modalPresentationStyle = .overFullScreen
            loading.modalTransitionStyle = .crossDissolve
            present(loading, animated: animated)
        } else if !loading && presentedViewController != nil {
            dismiss(animated: animated)
        }
    }
}

var remainingCheeses: [Cheese] = [
    Cheese(name: "Brillat Savarin", stinks: true, imageName: "brillat-savarin"),
    Cheese(name: "Brocciu", stinks: false, imageName: "brocciu"),
    Cheese(name: "Bucheron", stinks: true, imageName: "bucheron"),
    Cheese(name: "Cabrales", stinks: false, imageName: "cabrales"),
    Cheese(name: "Camembert", stinks: true, imageName: "camembert"),
    Cheese(name: "Cantal", stinks: false, imageName: "cantal"),
    Cheese(name: "Chabichou du Poitou", stinks: true, imageName: "chabichou-du-poitou"),
    Cheese(name: "Chaource", stinks: true, imageName: "chaource"),
    Cheese(name: "Emmental", stinks: false, imageName: "allgauer-emmentaler")
]
