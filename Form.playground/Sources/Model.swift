// MIT License
//
// Copyright (c) 2016 Jérémie Girault
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
    
    public static let usersKey = "users"
    
    private let duration: Double = 0.6
    private var users: [User] = [ User(name: "Bob", age: 21), User(name: "Alice", age: 24) ]
    
    private func modelDidChange() {
        NotificationCenter.default.post(name: .modelDidChange, object: self, userInfo: [ Storage.usersKey: users ])
    }
    
    public func list(complete: @escaping (Result<[User]>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            complete(.success(self.users))
        }
    }
    
    public func delete(user: User) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if let foundIndex = self.users.index(of: user) {
                self.users.remove(at: foundIndex)
            }
            self.modelDidChange()
        }
    }
    
    public func upsert(user: User) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if let exisingIndex = self.users.index(of: user) {
                self.users[exisingIndex] = user
            } else {
                self.users.append(user)
            }
            self.modelDidChange()
        }
    }
}
