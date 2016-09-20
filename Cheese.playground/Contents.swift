import UIKit
import PlaygroundSupport


final class Router {
    
    let rootViewController: UIViewController
    
    init() {
        let root = CheesesListController()
        let navigationController = UINavigationController(rootViewController: root)

        root.title = "Cheeses List"
        let addCheeseButton = UIBarButtonItem(barButtonSystemItem: .add, target: root, action: #selector(CheesesListController.addCheese))
        root.navigationItem.rightBarButtonItem = addCheeseButton

        root.cheeseTouched = {
            let cheeseDetailsController = CheeseDetailsController(cheese: $0)
            cheeseDetailsController.title = $0.name
            navigationController.pushViewController(cheeseDetailsController, animated: true)
        }
        rootViewController = navigationController
    }
}

PlaygroundPage.current.liveView = Router().rootViewController
