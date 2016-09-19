import UIKit

class LoaderViewController: UIViewController {
    
    let box = UIView()
    let stack = UIStackView()
    let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let label = UILabel()
    lazy var timer: Timer = self.createTimer()
  
    private func createTimer() -> Timer {
        let messages = [
            "Contacting the internets",
            "Waiting for cheese to melt",
            "Stinking sequence initialized" ]
        
        return Timer(timeInterval: 1.5, repeats: true) { [weak self] _ in
            self?.label.text = messages.randomElement
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.3)
        box.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
        box.layer.cornerRadius = 20
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        
        view.addSubview(box)
        view.addSubview(stack)
        stack.addArrangedSubview(activity)
        stack.addArrangedSubview(label)
        
        box.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            box.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            box.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            box.widthAnchor.constraint(equalToConstant: 150),
            box.heightAnchor.constraint(equalToConstant: 150),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 140),
            stack.heightAnchor.constraint(equalToConstant: 140),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activity.startAnimating()
        
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        timer.fire() //mini hack, trigger a loading text right now
    }
    
    deinit {
        timer.invalidate()
    }
}

