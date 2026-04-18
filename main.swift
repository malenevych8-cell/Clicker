import UIKit
import SpriteKit
import AudioToolbox

// --- СЦЕНА (ФІЗИКА ТА ПАДІННЯ) ---
class GameScene: SKScene {
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
    
    // Категорії для фізики
    struct PhysicsCategory {
        static let button: UInt32 = 0x1 << 0
        static let world: UInt32 = 0x1 << 1
    }

    override func didMove(to view: SKView) {
        // Чорний фон
        backgroundColor = .black
        
        // Створюємо фізичні межі *всього* екрана, а не тільки верху!
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.categoryBitMask = PhysicsCategory.world
        self.physicsBody = borderBody
        
        // Сильна гравітація вниз
        physicsWorld.gravity = CGVector(dx: 0, dy: -15.0)
        
        // Напис рахунку
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 45
        scoreLabel.fontColor = .cyan
        // Позиція рахунку зверху, під "острівцем"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.height - 150)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        // Створюємо кнопки
        let wait = SKAction.wait(forDuration: 1.0)
        let spawn = SKAction.run { [weak self] in self?.spawnButton() }
        run(SKAction.repeatForever(SKAction.sequence([wait, spawn])))
    }
    
    func spawnButton() {
        // Випадкова позиція по ширині
        let randomX = CGFloat.random(in: 50...(frame.width - 50))
        let buttonSize = CGSize(width: 80, height: 80)
        
        // Вигляд монети
        let button = SKShapeNode(circleOfRadius: 40)
        button.fillColor = .systemYellow
        button.strokeColor = .white
        button.lineWidth = 3
        button.position = CGPoint(x: randomX, y: frame.height + 100)
        button.name = "coin"
        
        // Текст TAP!
        let label = SKLabelNode(text: "TAP!")
        label.fontSize = 20
        label.fontName = "Arial-BoldMT"
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        // Фізичне тіло
        let body = SKPhysicsBody(circleOfRadius: 40)
        body.affectedByGravity = true
        body.allowsRotation = true
        body.restitution = 0.8 // Сильний відскок
        body.friction = 0.3
        
        body.categoryBitMask = PhysicsCategory.button
        body.collisionBitMask = PhysicsCategory.world | PhysicsCategory.button
        button.physicsBody = body
        
        // Випадкове закручування
        body.applyAngularImpulse(CGFloat.random(in: -0.5...0.5))
        
        addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes where node.name == "coin" {
            // Клік по монеті!
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            // Вібрація
            AudioServicesPlaySystemSound(1519)
            
            // Ефект зникнення
            node.name = "" // Прибираємо ім'я
            node.run(SKAction.sequence([
                SKAction.group([
                    SKAction.scale(to: 1.6, duration: 0.1),
                    SKAction.fadeOut(withDuration: 0.1)
                ]),
                SKAction.removeFromParent()
            ]))
        }
    }
}

// --- КОНТРОЛЕР (ВИПРАВЛЕННЯ ЧОРНОГО ЕКРАНА І МАСШТАБУ) ---
class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Створюємо SKView на весь екран
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        
        // Відладка (можна вимкнути)
        // skView.showsFPS = true
        // skView.showsNodeCount = true
        // skView.showsPhysics = true // Увімкни, щоб побачити зелені межі фізики
        
        // Створюємо сцену з точним розміром екрана
        let scene = GameScene(size: skView.bounds.size)
        
        // !!! КРИТИЧНЕ ВИПРАВЛЕННЯ !!!
        // resizeFill змушує сцену розтягнутися на весь екран iPhone
        scene.scaleMode = .resizeFill
        
        skView.presentScene(scene)
    }
    
    // Ховаємо статус-бар для чистоти
    override var prefersStatusBarHidden: Bool { return true }
}

// --- ДЕЛЕГАТ ---
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GameViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

// --- ЗАПУСК ---
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
