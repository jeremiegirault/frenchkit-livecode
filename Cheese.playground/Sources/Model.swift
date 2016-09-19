import UIKit

public struct Cheese {
    public let id: String
    public var name: String
    public var stinks: Bool
    public var image: UIImage?
    
    public init(name: String, stinks: Bool, image: UIImage? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.stinks = stinks
        self.image = image
    }
    
    static func byName(lhs: Cheese, rhs: Cheese) -> Bool {
        return lhs.name < rhs.name
    }
}

extension Cheese: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: Cheese, rhs: Cheese) -> Bool {
        return lhs.id == rhs.id
    }
}

public class CheeseStorage {
    public static let shared = CheeseStorage()
    
    public static let cheesesKey = "cheeses"
    
    private let duration: Double = 0.6
    private var cheeses: [Cheese] = [ Cheese(name: "Emmental", stinks: false), Cheese(name: "Camembert", stinks: true) ]
    
    private func modelDidChange() {
        NotificationCenter.default.post(name: .modelDidChange, object: self, userInfo: [ CheeseStorage.cheesesKey: cheeses ])
    }
    
    public func list(complete: @escaping (Result<[Cheese]>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            complete(.success(self.cheeses))
        }
    }
    
    public func delete(cheese: Cheese) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if let foundIndex = self.cheeses.index(of: cheese) {
                self.cheeses.remove(at: foundIndex)
            }
            self.modelDidChange()
        }
    }
    
    public func upsert(cheese: Cheese) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if let existingIndex = self.cheeses.index(of: cheese) {
                self.cheeses[existingIndex] = cheese
            } else {
                self.cheeses.append(cheese)
            }
            self.modelDidChange()
        }
    }
}
