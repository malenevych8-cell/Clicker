import UIKit
import SpriteKit
import AudioToolbox

// --- НАЛАШТУВАННЯ СЦЕНИ (ФІЗИКА ТА КЛІКИ) ---
class GameScene: SKScene {
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Межі екрану
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borderBody
        
        // Рахунок
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.height - 100)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        // Поява кнопок
        let spawn = SKAction.run { [weak self] in self?.createButton() }
        let wait = SKAction.wait(forDuration: 1.2)
        run(SKAction.repeatForever(SKAction.sequence([spawn, wait])))
    }
    
    func createButton() {
        let size = CGSize(width: 80, height: 80)
        let button = SKShapeNode(rectOf: size, cornerRadius: 15)
        button.fillColor = .systemRed
        button.position = CGPoint(x: CGFloat.random(in: 50...frame.width-50), y: frame.height + 50)
        button.name = "target"
        
        let body = SKPhysicsBody(rectangleOf: size)
        body.allowsRotation = true
        body.restitution = 0.5
        button.physicsBody = body
        
        addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes where node.name == "target" {
            score += 1
            scoreLabel.text = "Score: \(score)"
            AudioServicesPlaySystemSound(1519)
            node.removeFromParent()
        }
    }
}

// --- КОНТРОЛЕР ---
class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        let scene = GameScene(size: view.frame.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
}

// --- ДЕЛЕГАТ ДОДАТКА ---
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GameViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

// --- ЗАПУСК (Тільки для main.swift) ---
UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(AppDelegate.self)
)
