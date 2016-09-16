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

public final class CheesesListController: UITableViewController {
    
    private static let cellId = "CheeseCellId"
    private var cheeses: [Cheese] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cheeses List"
        let addCheeseButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CheesesListController.addCheese))
        navigationItem.rightBarButtonItem = addCheeseButton
        update()
        tableView.register(MyCell.self, forCellReuseIdentifier: CheesesListController.cellId)
        NotificationCenter.default.addObserver(forName: .modelDidChange, object: nil, queue: OperationQueue.main) { notification in
            if let cheeses = notification.userInfo?[CheeseStorage.cheesesKey] as? [Cheese], cheeses != self.cheeses {
                self.cheeses = cheeses
                self.tableView.reloadData()
            }
        }
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
