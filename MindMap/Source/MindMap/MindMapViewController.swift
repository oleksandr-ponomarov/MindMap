
import UIKit

protocol MindMapViewType: AnyObject {
    
}

class MindMapViewController: UIViewController {
    
    private let mapScrollView = MapScrollView()
    
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
        view.backgroundColor = .white
        setupMapScrollView()
    }
    
    func setupMapScrollView() {
        guard let presenter = presenter else { return }
        mapScrollView.configureUI(mapFile: presenter.mapFile)
        mapScrollView.mapDelegate = self
        
        view.addSubview(mapScrollView)
        mapScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

#if targetEnvironment(simulator)
import SwiftUI

@available(iOS 15, *)
struct MindMapViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        Group {
            UIKitControllerPreview {
                let viewController = MindMapViewController()
                let node = Node(name: "NodeName", centerPosition: .init())
                node.add(child: Node(name: "Child", centerPosition: .init(x: 100, y: 200)))
                let configurator =
                MindMapConfigurator(mapFile: MapFile(rootNode: node,
                                                     contentViewSize: .init()))
                configurator.configure(viewController: viewController)
                return viewController
            }
        }
    }
}
#endif
