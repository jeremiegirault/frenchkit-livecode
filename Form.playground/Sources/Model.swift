import Foundation

public typealias UserId = String

public struct User {
    public var name: String
    public var age: Int
    
    public init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

public class Storage {
    public static let shared = Storage()
    
    public func read(id: UserId, complete: @escaping (Result<User>) -> Void) {
        let user = User(name: "Paul", age: 75)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            complete(.success(user))
        }
    }
    
    public func update(user: User, complete: (Error?) -> Void) {
        complete(nil)
    }
}
