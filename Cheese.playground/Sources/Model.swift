import UIKit

public struct Cheese {
    public let id: String
    public var name: String
    public var stinks: Bool
    public var image: UIImage?
    
    public init(name: String, stinks: Bool, imageName: String) {
        self.id = UUID().uuidString
        self.name = name
        self.stinks = stinks
        self.image = imageName.cheeseImage
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
    private var cheeses: [Cheese] = [
        Cheese(name: "Abondance", stinks: false, imageName: "abondance"),
        Cheese(name: "Emmental", stinks: true, imageName: "allgauer-emmentaler"),
        Cheese(name: "Banon", stinks: true, imageName: "banon"),
        Cheese(name: "Bleu d'Auvergne", stinks: true, imageName: "bleu-dauvergne"),
        Cheese(name: "Bleu de Gex", stinks: true, imageName: "bleu-de-gex"),
        Cheese(name: "Brie de Meaux", stinks: true, imageName: "brie-de-meaux"),
        Cheese(name: "Brie", stinks: true, imageName: "brie"),
        Cheese(name: "Brillat Savarin", stinks: true, imageName: "brillat-savarin"),
        Cheese(name: "Brocciu", stinks: true, imageName: "brocciu"),
        Cheese(name: "Bucheron", stinks: true, imageName: "bucheron"),
        Cheese(name: "Cabrales", stinks: true, imageName: "cabrales"),
        Cheese(name: "Camembert", stinks: true, imageName: "camembert"),
        Cheese(name: "Cantal", stinks: true, imageName: "cantal"),
        Cheese(name: "Chabichou du Poitou", stinks: true, imageName: "chabichou-du-poitou"),
        Cheese(name: "Chaource", stinks: true, imageName: "chaource"),
        ]
    
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
