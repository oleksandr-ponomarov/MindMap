
import UIKit

protocol MapsListRouterType {
    func showMindMapScreen(with map: MapsListEntity)
    func showAddNewMapAlert(completion: @escaping (String) -> Void)
}

class MapsListRouter: MapsListRouterType {
    
    private weak var viewController: MapsListViewController?
    
    // MARK: - Protocol property
    
    init(viewController: MapsListViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Protocol methods
    
    func showMindMapScreen(with map: MapsListEntity) {
        let mindMapViewController = MindMapViewController()
        let configurator = MindMapConfigurator(with: map)
        mindMapViewController.assignment(configurator: configurator)
        viewController?.navigationController?.show(mindMapViewController, sender: nil)
    }
    
    func showAddNewMapAlert(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Hi",
                                      message: "Enter name your new map:",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "enter map name"
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            // TODO [AP]: - добавить валидацию на пустое поле (текстфилд)
            guard let textField = alert.textFields?.first,
                  let text = textField.text else { return }
            completion(text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
