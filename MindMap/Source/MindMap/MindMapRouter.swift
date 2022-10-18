
import UIKit

protocol MindMapRouterType {
    func showEditAlert(nodeView: NodeView)
}

final class MindMapRouter: MindMapRouterType {
    
    private weak var viewController: MindMapViewController?
    
    // MARK: - Protocol property
    
    init(viewController: MindMapViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Protocol methods
    
    func showEditAlert(nodeView: NodeView) {
        let textInput = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        textInput.addTextField { textField in
            textField.text = nodeView.text
            textField.placeholder = "Enter text"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = textInput.textFields?.first else { return }
            
            nodeView.setup(text: textField.text)
        }
        textInput.addAction(saveAction)
        viewController?.present(textInput, animated: true, completion: nil)
    }
}
