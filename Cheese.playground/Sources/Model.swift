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
