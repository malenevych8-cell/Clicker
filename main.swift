import UIKit

class ViewController: UIViewController {
    var score = 0
    var clickPower = 1
    var upgradeCost = 10
    
    let scoreLabel = UILabel()
    let upgradeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        scoreLabel.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: 60)
        scoreLabel.textAlignment = .center
        scoreLabel.font = .systemFont(ofSize: 50, weight: .bold)
        scoreLabel.text = "\(score)"
        view.addSubview(scoreLabel)
        
        let clickButton = UIButton(frame: CGRect(x: (view.frame.width - 200)/2, y: 300, width: 200, height: 200))
        clickButton.backgroundColor = .systemBlue
        clickButton.setTitle("TAP!", for: .normal)
        clickButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        clickButton.layer.cornerRadius = 100
        clickButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        view.addSubview(clickButton)
        
        upgradeButton.frame = CGRect(x: 50, y: 550, width: view.frame.width - 100, height: 60)
        upgradeButton.backgroundColor = .systemGreen
        upgradeButton.setTitleColor(.white, for: .normal)
        upgradeButton.setTitle("Upgrade (+1) - Cost: \(upgradeCost)", for: .normal)
        upgradeButton.layer.cornerRadius = 15
        upgradeButton.addTarget(self, action: #selector(handleUpgrade), for: .touchUpInside)
        view.addSubview(upgradeButton)
    }
    
    @objc func handleTap() {
        score += clickPower
        scoreLabel.text = "\(score)"
    }
    
    @objc func handleUpgrade() {
        if score >= upgradeCost {
            score -= upgradeCost
            clickPower += 1
            upgradeCost *= 3 
            scoreLabel.text = "\(score)"
            upgradeButton.setTitle("Upgrade (+1) - Cost: \(upgradeCost)", for: .normal)
        }
    }
}

autoreleasepool {
    UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(ViewController.self))
}
