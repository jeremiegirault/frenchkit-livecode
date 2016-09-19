import UIKit

public final class CheeseDetailsController: UIViewController {
    
    let stack = UIStackView()
    let nameLabel = UILabel()
    let stinksLabel = UILabel()
    let imageView = UIImageView()
    let cheese: Cheese
    
    public init(cheese: Cheese) {
        self.cheese = cheese
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        ])
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(stinksLabel)
        nameLabel.text = cheese.name
    }
    
}
