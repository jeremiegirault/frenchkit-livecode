import Foundation

class OptimisticUpdate {
    let apply: (inout [Cheese]) -> Void
    
    init(apply: @escaping (inout [Cheese]) -> Void) {
        self.apply = apply
    }
}

class OptimisticStorage {
    
    static let shared = OptimisticStorage()
    
    var updates = [OptimisticUpdate]()
    
    var list: [Cheese] {
        var copy = CheeseStorage.shared.list
        updates.forEach { $0.apply(&copy) }
        return copy
    }
    
    func remove(cheese: Cheese, complete: @escaping (Error?) -> Void) {
        
        let update = OptimisticUpdate { list in
            if let index = list.index(of: cheese) {
                list.remove(at: index)
            }
        }
        
        updates.append(update)
        CheeseStorage.shared.remove(cheese: cheese) { error in
            if error == nil {
                self.updates.remove(reference: update)
            }
            
            complete(error)
        }
    }
    
    func upsert(cheese: Cheese, complete: @escaping (Error?) -> Void) {
        let update = OptimisticUpdate(
            apply: { list in
                if let index = list.index(of: cheese) {
                    list[index] = cheese
                } else {
                    list.append(cheese)
                }
        })
        
        updates.append(update)
        
        CheeseStorage.shared.upsert(cheese: cheese, complete: { error in
            if error == nil {
                self.updates.remove(reference: update)
            }
            
            complete(error)
        })
    }
}
