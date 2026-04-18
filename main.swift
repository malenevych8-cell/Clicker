import UIKit
import SpriteKit
import AudioToolbox

// --- НАЛАШТУВАННЯ СЦЕНИ (ФІЗИКА ТА КЛІКИ) ---
class GameScene: SKScene {
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    
    override func didMove(to view: SKView) {
        // Чорний фон для OLED екрану iPhone 14
        backgroundColor = .black
        
        // Гравітація вниз
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // Межі екрану (фізичні стіни та підлога)
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borderBody
        
        // Рахунок (Score)
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 42
        scoreLabel.fontColor = .cyan
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.height - 120)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        // Поява золотих кнопок автоматично
        let spawn = SKAction.run { [weak self] in self?.createGoldenButton() }
        let wait = SKAction.wait(forDuration: 1.0) // Кнопка кожні 1 сек
        run(SKAction.repeatForever(SKAction.sequence([spawn, wait])))
    }
    
    func createGoldenButton() {
        let size = CGSize(width: 70, height: 70)
        
        // Дизайн золотої кнопки-монети
        let button = SKShapeNode(circleOfRadius: 35)
        button.fillColor = .systemYellow // Золотий колір
        button.strokeColor = .white
        button.lineWidth = 3
        button.position = CGPoint(x: CGFloat.random(in: 50...frame.width-50), y: frame.height + 50)
        button.name = "target"
        
        // Текст TAP! всередині кнопки
        let label = SKLabelNode(text: "TAP!")
        label.fontSize = 18
        label.fontName = "Arial-BoldMT"
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        // Фізика: оберт, відскок, гравітація
        let body = SKPhysicsBody(circleOfRadius: 35)
        body.affectedByGravity = true
        body.allowsRotation = true
        body.restitution = 0.6 // Добре відскакує від підлоги
        body.friction = 0.4
        button.physicsBody = body
        
        // Випадковий імпульс обертання при появі
        body.applyAngularImpulse(CGFloat.random(in: -0.3...0.3))
        
        addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes where node.name == "target" {
            // Клік!
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            // Чітка вібрація (Haptic Feedback)
            AudioServicesPlaySystemSound(1519)
            
            // Ефект "вибуху" при кліку (збільшення і зникнення)
            node.name = "" // Прибираємо ім'я, щоб не можна було клікнути двічі
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.1)
            let fadeOut = SKAction.fadeOut(withDuration: 0.1)
            let group = SKAction.group([scaleUp, fadeOut])
            let remove = SKAction.removeFromParent()
            node.run(SKAction.sequence([group, remove]))
        }
    }
}

// --- КОНТРОЛЕР ---
class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        // skView.showsPhysics = true // Увімкни, щоб бачити фізичні межі (для відладки)
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

// --- ЗАПУСК (Для main.swift) ---
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
