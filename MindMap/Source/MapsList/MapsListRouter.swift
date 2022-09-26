
import UIKit

protocol MapsListRouterType {
    func showMindMapScreen(mapFile: MapFile)
    func showAddNewMapAlert(completion: @escaping (String?) -> Void)
}

final class MapsListRouter: MapsListRouterType {
    
    private weak var viewController: MapsListViewController?
    
    // MARK: - Protocol property
    
    init(viewController: MapsListViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Protocol methods
    
    func showMindMapScreen(mapFile: MapFile) {
        let mindMapViewController = MindMapViewController()
        let configurator = MindMapConfigurator(mapFile: mapFile)
        configurator.configure(viewController: mindMapViewController)
        viewController?.navigationController?.pushViewController(mindMapViewController, animated: true)
    }
    
    func showAddNewMapAlert(completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: nil,
                                      message: "Enter map name:",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        let okAction = UIAlertAction(title: "Create", style: .default) { _ in
            guard let textField = alert.textFields?.first else { return }
            
            completion(textField.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
