import Foundation

extension Notification.Name {
    public static let modelDidChange = NSNotification.Name("ModelDidChange")
}

public typealias UserId = String

public struct User {
    public let id: UserId
    public var name: String
    public var age: Int
    
    public init(name: String, age: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.age = age
    }
    
    static func byName(lhs: User, rhs: User) -> Bool {
        return lhs.name < rhs.name
    }
}

extension User: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

public class Storage {
    public static let shared = Storage()
    
    private var users: Set<User> = [ User(name: "Bob", age: 21), User(name: "Alice", age: 24) ]
    
    var sortedUsers: [User] { return users.sorted(by: User.byName) }
    
    private func modelDidChange() {
        NotificationCenter.default.post(name: .modelDidChange, object: self, userInfo: [ "users": sortedUsers ])
    }
    
    public func list(complete: @escaping (Result<[User]>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            complete(.success(self.sortedUsers))
        }
    }
    
    public func delete(user: User) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.users.remove(user)
            self.modelDidChange()
        }
    }
    
    public func upsert(user: User) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.users.remove(user)
            self.users.insert(user)
            self.modelDidChange()
        }
    }
}
