import UIKit

public final class CheesesListController: UITableViewController {
    
    private let storage = OptimisticStorage.shared
    public var cheeseTouched: ((Cheese) -> Void)?
    
    // uiviewcontroller
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CheeseCell.self, forCellReuseIdentifier: CheeseCell.identifier)
    }
    
    // table view datasource/delegate
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheeseCell.identifier, for: indexPath)
        let cheese = storage.list[indexPath.row]
        
        cell.textLabel?.text = cheese.name
        let stinks = cheese.stinks ? "🙊" : "🙂"
        cell.detailTextLabel?.text = "stinks: \(stinks)"
        cell.imageView?.image = cheese.image.flatMap(UIImage.init)
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.list.count
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cheese = storage.list[indexPath.row]
        cheeseTouched?(cheese)
    }
    
    public override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            
            guard let cheese = self?.storage.list[indexPath.row] else { return }
            self?.removeCheese(cheese: cheese)
        }
        return [ action ]
    }
    
    // operations
    
    func removeCheese(cheese: Cheese) {
        optimisticOperation { complete in
            remainingCheeses.append(cheese)
            storage.remove(cheese: cheese, complete: complete)
        }
    }
    
    @objc public func addCheese() {
        guard !remainingCheeses.isEmpty else { return }
        
        optimisticOperation { complete in
            let cheese = remainingCheeses.removeFirst()
            storage.upsert(cheese: cheese, complete: complete)
        }
    }
    
    // helper
    
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
    
    func optimisticOperation(_ start: (@escaping (Error?) -> Void) -> Void) {
        start { error in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
            }
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = !remainingCheeses.isEmpty
        tableView.reloadData()
    }
}







/// Cheese TableView Cell

final class CheeseCell: UITableViewCell {
    
    static let identifier = "\(self)"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
