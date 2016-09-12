// MIT License
//
// Copyright (c) 2016 Jérémie Girault
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
        
        title = "User List"
        
        let addUserButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        
        navigationItem.rightBarButtonItem = addUserButton
        
        tableView.register(MyCell.self, forCellReuseIdentifier: MasterViewController.cellId)
        
        NotificationCenter.default.addObserver(forName: .modelDidChange, object: nil, queue: OperationQueue.main) { notification in
            if let users = notification.userInfo?[UserStorage.usersKey] as? [User], users != self.users {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    func update() {
        UserStorage.shared.list { result in
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
        let form = DetailsViewController()
        form.title = user.name
        navigationController?.pushViewController(form, animated: true)
    }
    
    public override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            tableView.beginUpdates()
            let user = self.users.remove(at: indexPath.row)
            tableView.deleteRows(at: [ indexPath ], with: .automatic)
            tableView.endUpdates()
            
            UserStorage.shared.delete(user: user)
        }
        return [ action ]
    }
    
    let firstNames = [ "Joe", "Jane", "Bob", "Alice", "Greg", "Emily" ]
    let lastNames1 = [ "Apple", "Dumble", "Humble", "White", "Grey" ]
    let lastNames2 = [ "seed", "doe", "goose", "man", "door" ]
    
    @objc private func addUser() {
        let (n1, n2, n3) = (firstNames.randomElement, lastNames1.randomElement, lastNames2.randomElement)
        let newUser = User(name: "\(n1) \(n2)\(n3)", age: (16..<99).randomElement)
        
        tableView.beginUpdates()
        users.append(newUser)
        tableView.insertRows(at: [ IndexPath(row: users.count-1, section: 0) ], with: .automatic)
        tableView.endUpdates()
        
        UserStorage.shared.upsert(user: newUser)
    }
}
