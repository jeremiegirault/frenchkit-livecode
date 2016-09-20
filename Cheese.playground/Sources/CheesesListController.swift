import UIKit

private var remainingCheeses: [Cheese] = [
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

public final class CheesesListController: UITableViewController {
    
    private var data: [Cheese] { return CheeseStorage.shared.list }
    
    public var cheeseTouched: ((Cheese) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CheeseCell.self, forCellReuseIdentifier: CheeseCell.identifier)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheeseCell.identifier, for: indexPath)
        let cheese = data[indexPath.row]
        
        cell.textLabel?.text = cheese.name
        let stinks = cheese.stinks ? "🙊" : "🙂"
        cell.detailTextLabel?.text = "stinks: \(stinks)"
        cell.imageView?.image = cheese.image.flatMap(UIImage.init)
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cheese = data[indexPath.row]
        cheeseTouched?(cheese)
    }
    
    public override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            
            guard let cheese = self?.data[indexPath.row] else { return }
            self?.removeCheese(cheese: cheese)
        }
        return [ action ]
    }
    
    func removeCheese(cheese: Cheese) {
        longOperation { complete in
            remainingCheeses.append(cheese)
            CheeseStorage.shared.remove(cheese: cheese, complete: complete)
        }
    }
    
    @objc public func addCheese() {
        guard !remainingCheeses.isEmpty else { return }
        
        longOperation { complete in
            let cheese = remainingCheeses.removeFirst()
            CheeseStorage.shared.upsert(cheese: cheese, complete: complete)
        }
    }
    
    func longOperation(_ start: (@escaping (Error?) -> Void) -> Void) {
        setLoading(true, animated: true)
        start { error in
            self.navigationItem.rightBarButtonItem?.isEnabled = !remainingCheeses.isEmpty
            self.setLoading(false, animated: true)
            self.tableView.reloadData()
            
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

final class CheeseCell: UITableViewCell {
    
    static let identifier = "\(self)"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
