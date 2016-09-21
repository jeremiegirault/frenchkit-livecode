import Foundation

class OptimisticUpdate {
    let update: (inout [Cheese]) -> Void
    private let _execute: (OptimisticUpdate) -> Void
    private let _rollback: (OptimisticUpdate) -> Void
    
    init(update: @escaping (inout [Cheese]) -> Void,
         execute: @escaping (OptimisticUpdate) -> Void,
         rollback: @escaping (OptimisticUpdate) -> Void) {
        self.update = update
        _execute = execute
        _rollback = rollback
    }
    
    func execute() {
        _execute(self)
    }
    
    func rollback() {
        _rollback(self)
    }
}

class OptimisticModel {
    
    static let shared = OptimisticModel()
    
    private var updates = [OptimisticUpdate]()
    
    var list: [Cheese] {
        var copy = CheeseStorage.shared.list
        updates.forEach { $0.update(&copy) }
        return copy
    }
    
    func remove(cheese: Cheese, complete: @escaping (Error?, OptimisticUpdate) -> Void) {
        let update = OptimisticUpdate(
            update: { list in
                if let index = list.index(of: cheese) {
                    list.remove(at: index)
                }
            },
            execute: { update in
                CheeseStorage.shared.remove(cheese: cheese) { error in
                    if error == nil { self.updates.remove(reference: update) }
                    complete(error, update)
                }
            },
            rollback: { self.updates.remove(reference: $0) }
        )
        
        updates.append(update)
        update.execute()
    }
    
    func upsert(cheese: Cheese, complete: @escaping (Error?, OptimisticUpdate) -> Void) {
        let update = OptimisticUpdate(
            update:  { list in
                if let index = list.index(of: cheese) {
                    list[index] = cheese
                } else {
                    list.append(cheese)
                }
            },
            execute: { update in
                CheeseStorage.shared.upsert(cheese: cheese) { error in
                    if error == nil { self.updates.remove(reference: update) }
                    complete(error, update)
                }
            }, rollback: { self.updates.remove(reference: $0) })
        
        updates.append(update)
        update.execute()
    }
}
