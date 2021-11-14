
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
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let ideasView = ideasView else { return }
        
        loadIdeas()
        
        if ideasView.subviews.isEmpty {
            let ideaView = IdeaView(CGPoint(x: ideasView.frame.midX,
                                            y: ideasView.frame.midY),
                                    ideaText: presenter?.mapName ?? "")
            ideaView.delegate = self
            ideasView.addSubview(ideaView)
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        scrollView?.setContentOffset(CGPoint(x: (contentSize - view.frame.size.width) / 2,
                                            y: (contentSize - view.frame.size.height) / 2),
                                    animated: false)
        scrollView?.isScrollEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.saveIdeas(views: ideasView?.subviews)
    }
    
    func assignment(configurator: MindMapConfiguratorType) {
        self.configurator = configurator
    }
    
    func loadIdeas() {
        if let ideas = UserDefaults.standard.array(forKey: "ideas") as? [[String: String]] {
            for idea in ideas {
                guard let center = idea["center"],
                        let uuid = idea["uuid"],
                        let text = idea["text"] else { return }
                
                let ideaCenter: CGPoint = NSCoder.cgPoint(for: center)
                let ideaView = IdeaView(ideaCenter, ideaText: "")
                ideaView.uuid = uuid
                ideasView?.addSubview(ideaView)
                ideaView.setupIdeaText(text: text)
                ideaView.delegate = self
            }
        }
        
        if let lines = UserDefaults.standard.array(forKey: "lines") as? [[String: String]] {
            for line in lines {
                let fromUuid = line["fromUuid"]
                let toUuid = line["toUuid"]
                if let fromView = getIdeaViewForUuid(uuid: fromUuid!) {
                    if let toView = getIdeaViewForUuid(uuid: toUuid!) {
                        let line = LineView(from: fromView, to: toView)
                        ideasView?.insertSubview(line, at: 0)
                        fromView.lines.append(line)
                        toView.lines.append(line)
                    }
                }
            }
        }
    }
    
    func getIdeaViewForUuid(uuid: String) -> IdeaView? {
        guard let ideasViews = ideasView?.subviews else { return nil }
        
        for view in ideasViews {
            if view.isKind(of: IdeaView.self) {
                let ideaView = view as? IdeaView
                if ideaView?.uuid == uuid {
                    return ideaView
                }
            }
        }
        return nil
    }
    
    func saveIdeas() {
        guard let ideasViews = ideasView?.subviews else { return }
        
        var ideas = [[String: String]]()
        var lines = [[String: String]]()
        
        for view in ideasViews {
            if view.isKind(of: IdeaView.self) {
                guard let ideaView = view as? IdeaView else { return }
                ideas.append(ideaView.data)
            } else if view.isKind(of: LineView.self) {
                guard let lineView = view as? LineView else { return }
                lines.append(lineView.data)
            }
        }
        if ideas.count > 0 {
            UserDefaults.standard.set(ideas, forKey: "ideas")
            if lines.count > 0 {
                UserDefaults.standard.set(lines, forKey: "lines")
            }
        }
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
    
    func didChange() {
        presenter?.saveIdeas(views: ideasView?.subviews)
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
}
