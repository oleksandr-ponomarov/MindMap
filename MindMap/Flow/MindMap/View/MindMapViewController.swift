
import UIKit

protocol MindMapViewType: AnyObject {
    
}

class MindMapViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var ideasView: UIView!
    
    var presenter: MindMapPresenterType?
    private var configurator: MindMapConfiguratorType = MindMapConfigurator()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(viewController: self)
        presenter?.viewDidLoad()
        
        scrollView.isScrollEnabled = false
        
        let ideaCloudView = IdeaCloudView(CGPoint(x: ideasView.frame.midX,
                                                  y: ideasView.frame.midY),
                                          ideaText: "Text")
        ideaCloudView.delegate = self
        ideasView.addSubview(ideaCloudView)
        
//        let ideaCloudView = IdeaCloudView(CGPoint(x: 100,
//                                                  y: 100),
//                                          ideaText: "Text")
        

    }
    
    override func viewDidLayoutSubviews() {

    }
}

// MARK: - MindMapViewType
extension MindMapViewController: MindMapViewType {
    
}

extension MindMapViewController: IdeaCloudViewDelegate {
    func didDoubleTap(_ ideaCloudView: IdeaCloudView) {
        print("AP: MindMapViewController didDoubleTap")
        
        let textInput = UIAlertController(title: "Edit idea", message: nil, preferredStyle: .alert)
        textInput.addTextField { (textField) in
            textField.text = ideaCloudView.ideaText
        }
        textInput.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            guard let textField = textInput.textFields?.first else { return }
            ideaCloudView.setupIdeaText(text: textField.text)
        }))
        self.present(textInput, animated: true, completion: nil)
    }
}

// MARK: - Private methods
private extension MindMapViewController {
    func configureUI() {
        
    }
}
