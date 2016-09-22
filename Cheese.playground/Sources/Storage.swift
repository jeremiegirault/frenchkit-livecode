import Foundation

final class CheeseStorage {
    static let shared = CheeseStorage()
    
    private let delay: Double = 2.0
    private let probabilityOfError: Double = 0.7
    
    private var availableCheeses: [Cheese] = [
        Cheese(name: "Abondance", stinks: false, imageName: "abondance"),
        Cheese(name: "Banon", stinks: true, imageName: "banon"),
        Cheese(name: "Bleu d'Auvergne", stinks: true, imageName: "bleu-dauvergne"),
        Cheese(name: "Bleu de Gex", stinks: true, imageName: "bleu-de-gex"),
        Cheese(name: "Brie de Meaux", stinks: false, imageName: "brie-de-meaux"),
        Cheese(name: "Brie", stinks: true, imageName: "brie")
    ]
    
    private func afterDelay(then: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: then)
    }
    
    private func randomError(_ message: String, _ completion: (Error?) -> Void, or defaultBehavior: () -> Void) {
        let error = NSError(domain: "cheese", code: 42, userInfo: [ NSLocalizedDescriptionKey: message ])
        if arc4random() % 100 < UInt32(probabilityOfError*100) {
            completion(error)
        } else {
            defaultBehavior()
        }
    }
    
    var list: [Cheese] {
        return availableCheeses
    }
    
    func remove(cheese: Cheese, complete: @escaping (Error?) -> Void) {
        afterDelay {
            self.randomError("Could not delete \(cheese)", complete, or: {
                if let foundIndex = self.availableCheeses.index(of: cheese) {
                    self.availableCheeses.remove(at: foundIndex)
                }
                complete(nil)
            })
        }
    }
    
    func upsert(cheese: Cheese, complete: @escaping (Error?) -> Void) {
        afterDelay {
            self.randomError("Could not upsert \(cheese)", complete, or: {
                if let existingIndex = self.availableCheeses.index(of: cheese) {
                    self.availableCheeses[existingIndex] = cheese
                } else {
                    self.availableCheeses.append(cheese)
                }
                complete(nil)
            })
        }
        
    }
}
