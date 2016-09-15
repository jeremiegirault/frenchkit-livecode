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

import UIKit

public struct Cheese {
    public let id: String
    public var name: String
    public var stinks: Bool
    public var image: UIImage?
    
    public init(name: String, stinks: Bool) {
        self.id = UUID().uuidString
        self.name = name
        self.stinks = stinks
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
