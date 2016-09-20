import Foundation

public class CheeseStorage {
    public static let shared = CheeseStorage()
    
    public static let cheesesKey = "cheeses"
    
    private let duration: Double = 0.6
    private var cheeses: [Cheese] = [
        Cheese(name: "Abondance", stinks: false, imageName: "abondance"),
        Cheese(name: "Banon", stinks: true, imageName: "banon"),
        Cheese(name: "Bleu d'Auvergne", stinks: true, imageName: "bleu-dauvergne"),
        Cheese(name: "Bleu de Gex", stinks: true, imageName: "bleu-de-gex"),
        Cheese(name: "Brie de Meaux", stinks: false, imageName: "brie-de-meaux"),
        Cheese(name: "Brie", stinks: true, imageName: "brie")
    ]
    
    public var availableCheeses: [Cheese] = [
        Cheese(name: "Brillat Savarin", stinks: true, imageName: "brillat-savarin"),
        Cheese(name: "Brocciu", stinks: false, imageName: "brocciu"),
        Cheese(name: "Bucheron", stinks: true, imageName: "bucheron"),
        Cheese(name: "Cabrales", stinks: false, imageName: "cabrales"),
        Cheese(name: "Camembert", stinks: true, imageName: "camembert"),
        Cheese(name: "Cantal", stinks: false, imageName: "cantal"),
        Cheese(name: "Chabichou du Poitou", stinks: true, imageName: "chabichou-du-poitou"),
        Cheese(name: "Chaource", stinks: true, imageName: "chaource"),
        Cheese(name: "Emmental", stinks: false, imageName: "allgauer-emmentaler")
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
