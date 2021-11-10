
import UIKit

protocol MindMapViewType: AnyObject {
    
}

class MindMapViewController: UIViewController {
    
    var presenter: MindMapPresenterType?
    private var configurator: MindMapConfiguratorType?
    private var scrollView: UIScrollView?
    private var ideasView: UIView?
    
    private let contentSize: CGFloat = 5000
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator?.configure(viewController: self)
        presenter?.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        ideasView = UIView(frame: CGRect(x: 0, y: 0, width: contentSize, height: contentSize))
        
        guard let scrollView = scrollView,
              let ideasView = ideasView else { return }
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: contentSize, height: contentSize)
       
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        scrollView.addSubview(ideasView)
        view.addSubview(scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let ideasView = ideasView else { return }
        
        let ideaView = IdeaView(CGPoint(x: ideasView.frame.midX,
                                        y: ideasView.frame.midY),
                                ideaText: presenter?.mapName ?? "")
        ideaView.delegate = self
        ideasView.addSubview(ideaView)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        scrollView?.setContentOffset(CGPoint(x: (contentSize - view.frame.size.width) / 2,
                                            y: (contentSize - view.frame.size.height) / 2),
                                    animated: false)
    }
    
    func assignment(configurator: MindMapConfiguratorType) {
        self.configurator = configurator
    }
}

// MARK: - MindMapViewType
extension MindMapViewController: MindMapViewType {
    
}

extension MindMapViewController: IdeaCloudViewDelegate {
    func didDoubleTap(_ ideaCloudView: IdeaView) {
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

// MARK: - UIScrollViewDelegate
extension MindMapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ideasView
    }
}

// MARK: - Private methods
private extension MindMapViewController {
    func configureUI() {
        
    }
}
