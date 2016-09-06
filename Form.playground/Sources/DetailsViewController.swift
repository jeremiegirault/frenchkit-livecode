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

public final class DetailsViewController: UIViewController {
    
    let stack = UIStackView()
    let name = UITextField()
    let age = UITextField()
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var user: User? {
        didSet {
            name.text = user?.name
            if let userAge = user?.age {
                age.text = "\(userAge)"
            } else {
                age.text = ""
            }
        }
    }
    
    var saveButton: UIBarButtonItem!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        view.backgroundColor = .white
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
            ])
        
        name.placeholder = "Name"
        name.borderStyle = .roundedRect
        name.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        
        age.placeholder = "Age"
        age.borderStyle = .roundedRect
        age.keyboardType = .numberPad
        age.addTarget(self, action: #selector(ageDidChange), for: .editingChanged)
        
        stack.addArrangedSubview(indicatorView)
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(age)
        
        setForm(hidden: true)
        
        navigationItem.rightBarButtonItem = saveButton
        
        /*Storage.shared.read(id: "") {
         switch $0 {
         case .success(let user):
         self.setForm(hidden: false)
         self.user = user
         self.validateForm()
         case .failure(let error):
         self.alert(title: "Error", message: error.localizedDescription)
         }
         }*/
        
    }
    
    func setForm(hidden: Bool) {
        if hidden {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
        
        indicatorView.isHidden = !hidden
        name.isHidden = hidden
        age.isHidden = hidden
    }
    
    var isNameValid: Bool {
        return !(name.text ?? "").isEmpty
    }
    
    var isAgeValid: Bool {
        if let text = age.text {
            return Int(text) != nil
        }
        
        return false
    }
    
    @objc func nameDidChange(sender: UITextField) {
        validateForm()
    }
    
    @objc func ageDidChange(sender: UITextField) {
        validateForm()
    }
    
    func validateForm() {
        name.backgroundColor = isNameValid ? .green : .red
        age.backgroundColor = isAgeValid ? .green : .red
        
        saveButton.isEnabled = (isNameValid && isAgeValid)
    }
    
    @objc func save() {
        guard let userName = name.text, !userName.isEmpty else { return }
        guard let ageText = age.text, let userAge = Int(ageText) else { return }
        
        let user = User(name: userName, age: userAge)
    }
}
