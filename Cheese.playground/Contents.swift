import UIKit
import PlaygroundSupport

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

PlaygroundPage.current.liveView = navigationController

