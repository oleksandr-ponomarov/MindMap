
import UIKit

protocol MindMapViewType: AnyObject {
    
}

class MindMapViewController: UIViewController {
    
    private var mapScrollView = MapScrollView()
    
    var presenter: MindMapPresenterType?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - MindMapViewType
extension MindMapViewController: MindMapViewType {
    
}

// MARK: - MapScrollViewDelegate
extension MindMapViewController: MapScrollViewDelegate {
    func mapScrollView(_ mapScrollView: MapScrollView, didSelectNodeView nodeView: NodeView) {
        let textInput = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        textInput.addTextField { (textField) in
            textField.text = nodeView.text
            textField.placeholder = "Enter text"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = textInput.textFields?.first else { return }
            
            nodeView.setup(text: textField.text)
        }
        textInput.addAction(saveAction)
        present(textInput, animated: true, completion: nil)
    }
}

// MARK: - Private methods
private extension MindMapViewController {
    func configureUI() {
        guard let presenter = presenter else { return }
        
        view.addSubview(mapScrollView)
        setupMapScrollView()
        mapScrollView.configureUI(mapFile: presenter.mapFile)
        mapScrollView.mapDelegate = self
    }
    
    func setupMapScrollView() {
        mapScrollView.translatesAutoresizingMaskIntoConstraints = false
        mapScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}
