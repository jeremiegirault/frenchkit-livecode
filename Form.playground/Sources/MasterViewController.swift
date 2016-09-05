import UIKit

class MyCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

public final class MasterViewController: UITableViewController {
    
    private static let cellId = "UserCellId"
    private var users: [User] = []
    
    public var onUserSelected: ((User) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
        
        title = "User List"
        
        let addUserButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        
        navigationItem.rightBarButtonItem = addUserButton
        
        tableView.register(MyCell.self, forCellReuseIdentifier: MasterViewController.cellId)
        
        NotificationCenter.default.addObserver(forName: .modelDidChange, object: nil, queue: OperationQueue.main) { notification in
            print("hello -> \(notification.userInfo?["users"])")
            if let users = notification.userInfo?["users"] as? [User] {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    func update() {
        Storage.shared.list { result in
            switch result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
            case .failure(let error):
                self.alert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MasterViewController.cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "\(user.age) y.o"
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        onUserSelected?(user)
    }
    
    public override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            tableView.beginUpdates()
            let user = self.users.remove(at: indexPath.row)
            tableView.deleteRows(at: [ indexPath ], with: .automatic)
            tableView.endUpdates()
            
            Storage.shared.delete(user: user)
        }
        return [ action ]
    }
    
    @objc private func addUser() {
        let newUser = User(name: "Joe", age: 18)
        
        tableView.beginUpdates()
        users.append(newUser)
        tableView.insertRows(at: [ IndexPath(row: 0, section: 0) ], with: .automatic)
        tableView.endUpdates()
        Storage.shared.upsert(user: newUser)
    }
}
