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

import Swift
import UIKit

public enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Collection {
    public var randomElement: Iterator.Element {
        let distance = self.distance(from: self.startIndex, to: self.endIndex)
        let randomDistance = arc4random_uniform(numericCast(distance))
        let randomIndex = self.index(self.startIndex, offsetBy: numericCast(randomDistance))
        return self[randomIndex]
    }
}

extension UIViewController {
    public func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(closeAction)
        present(alertController, animated: true)
    }
}

