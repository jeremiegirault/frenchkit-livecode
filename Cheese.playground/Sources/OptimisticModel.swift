import Foundation

class OptimisticModel {
    
    static let shared = OptimisticModel()
    
    var list: [Cheese] {
        return CheeseStorage.shared.list
    }
    
    func remove(cheese: Cheese, complete: @escaping (Error?) -> Void) {
        CheeseStorage.shared.remove(cheese: cheese) { error in
            complete(error)
        }
    }
    
    func upsert(cheese: Cheese, complete: @escaping (Error?) -> Void) {
        CheeseStorage.shared.upsert(cheese: cheese) { error in
            complete(error)
        }
    }
}
