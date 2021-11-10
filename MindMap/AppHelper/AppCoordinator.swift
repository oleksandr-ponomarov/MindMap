
import UIKit

class AppCoordinator {
    static let shared = AppCoordinator()
    
    private weak var appDelegate: AppDelegate?
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func start() {
        appDelegate?.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate?.window?.rootViewController = startViewController()
        appDelegate?.window?.makeKeyAndVisible()
    }
        
    private func startViewController() -> UINavigationController {
        let mapsListViewController = MapsListViewController()
//        let mapsListViewController = MindMapViewController()
        let navigationController = UINavigationController(rootViewController: mapsListViewController)
        return navigationController
    }
}
