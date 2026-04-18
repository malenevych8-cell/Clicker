import UIKit

class ViewController: UIViewController {
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let label = UILabel(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 50))
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.text = "Score: 0"
        view.addSubview(label)
        
        let button = UIButton(frame: CGRect(x: (view.frame.width - 200)/2, y: 350, width: 200, height: 100))
        button.backgroundColor = .systemBlue
        button.setTitle("CLICK!", for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(btnTap), for: .touchUpInside)
        view.addSubview(button)
        
        self.scoreLabel = label
    }
    
    var scoreLabel: UILabel?
    
    @objc func btnTap() {
        score += 1
        scoreLabel?.text = "Score: \(score)"
    }
}

// Запуск додатку без AppDelegate (спрощено)
import UIKit
autoreleasepool {
    UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(ViewController.self))
}