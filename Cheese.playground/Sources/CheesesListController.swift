import UIKit

public final class CheesesListController: UITableViewController {
    
    private static let cellId = "CheeseCellId"
    private var cheeses: [Cheese] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        update()
        tableView.register(MyCell.self, forCellReuseIdentifier: CheesesListController.cellId)
        NotificationCenter.default.addObserver(forName: .modelDidChange, object: nil, queue: OperationQueue.main) { notification in
            if let cheeses = notification.userInfo?[CheeseStorage.cheesesKey] as? [Cheese], cheeses != self.cheeses {
                self.cheeses = cheeses
                self.tableView.reloadData()
            }
        }
        title = "Cheeses List"
        let addCheeseButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CheesesListController.addCheese))
        navigationItem.rightBarButtonItem = addCheeseButton
    }
    
    func update() {
        CheeseStorage.shared.list { result in
            switch result {
            case .success(let cheeses):
                self.cheeses = cheeses
                self.tableView.reloadData()
            case .failure(let error):
                self.alert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheesesListController.cellId, for: indexPath)
        let cheese = cheeses[indexPath.row]
        cell.textLabel?.text = cheese.name
        cell.detailTextLabel?.text = cheese.stinks ? "🙊" : "🙂"
        cell.imageView?.image = cheese.image
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cheeses.count
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cheese = cheeses[indexPath.row]
        let cheeseDetailsController = CheeseDetailsController(cheese: cheese)
        cheeseDetailsController.title = cheese.name
        navigationController?.pushViewController(cheeseDetailsController, animated: true)
    }
    
    public override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            tableView.beginUpdates()
            let cheese = self.cheeses.remove(at: indexPath.row)
            tableView.deleteRows(at: [ indexPath ], with: .automatic)
            tableView.endUpdates()
            
            CheeseStorage.shared.delete(cheese: cheese)
        }
        return [ action ]
    }
    
    let cheeseNames = [ "Brie", "Comte", "Roquefort", "Tomme", "Beaufort", "Livarot", "Maroilles", "Langres" ]
    
    @objc public func addCheese() {
        let newCheese = Cheese(name: cheeseNames.randomElement, stinks: Bool.random())
        
        tableView.beginUpdates()
        cheeses.append(newCheese)
        tableView.insertRows(at: [ IndexPath(row: cheeses.count-1, section: 0) ], with: .automatic)
        tableView.endUpdates()
        
        CheeseStorage.shared.upsert(cheese: newCheese)
    }
}

class MyCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
