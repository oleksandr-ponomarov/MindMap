
import UIKit

protocol NodeViewDelegate: AnyObject {
    func nodePanEnded(_ nodeView: NodeView, location: CGPoint)
    func nodeDoubleTapped(_ nodeView: NodeView)
    func nodeEditTapped(_ nodeView: NodeView)
    func nodeRemoveTapped(_ nodeView: NodeView)
}

final class NodeView: UIView {
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.frame = bounds
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var contextMenu: UIMenu = {
        let removeIcon = UIImage(systemName: "minus.circle.fill")
        let editIcon = UIImage(systemName: "square.and.pencil")
        
        let editAction = UIAction(title: "Edit", image: editIcon, identifier: nil, discoverabilityTitle: nil) { _ in
            self.delegate?.nodeEditTapped(self)
        }
        let removeAction = UIAction(title: "Remove", image: removeIcon, identifier: nil, discoverabilityTitle: nil, attributes: .destructive) { _ in
            self.delegate?.nodeRemoveTapped(self)
        }
        return UIMenu(title: "Setting", image: nil, options: [.displayInline], children: [editAction, removeAction])
    }()
    
    var uuid = UUID().uuidString
    let node: Node
    var lines: [LineView] = []
    
    private let borderWidth: CGFloat = 5
    private let borderColor: UIColor = .black
    private let height: CGFloat = 100
    private let minWight: CGFloat = 200
    private let maxWight: CGFloat = 500
    private let padding: CGFloat = 10
    
    weak var delegate: NodeViewDelegate?
    
    var text: String {
        return textLabel.text ?? ""
    }
    
    init(position: CGPoint, node: Node) {
        self.node = node
        let frame = CGRect(x: position.x - (minWight / 2),
                           y: position.y - (height / 2),
                           width: minWight,
                           height: height)
        super.init(frame: frame)
        textLabel.text = node.name
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func setup(text: String?) {
        textLabel.text = text
        updateFrame()
    }
    
    func delete() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.lines.forEach { $0.removeFromSuperview() }
            self.removeFromSuperview()
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension NodeView: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let contextMenuConfiguration = UIContextMenuConfiguration(identifier: "id" as NSCopying, previewProvider: nil) { _ in
            return self.contextMenu
        }
        return contextMenuConfiguration
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
}

// MARK: - Private methods
private extension NodeView {
    func commonInit() {
        setupUI()
        setupContextMenu()
        setupGestures()
    }
    
    func setupUI() {
        backgroundColor = .systemBlue
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerCurve = .continuous
        layer.cornerRadius = 20
        clipsToBounds = true
        
        addSubview(textLabel)
    }
    
    func setupContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
    }
    
    func updateFrame() {
        let labelSize = textLabel.sizeThatFits(CGSize(width: maxWight - padding * 2, height: height - padding * 2))
        let viewWidth = max(minWight, labelSize.width + padding * 2)
        
        textLabel.frame = CGRect(x: padding,
                                 y: padding,
                                 width: viewWidth - padding * 2,
                                 height: height - padding * 2)
        frame = CGRect(x: center.x - (viewWidth / 2),
                       y: center.y - (height / 2),
                       width: viewWidth,
                       height: height)
        setNeedsDisplay()
    }
    
    // MARK: - UIContextMenuConfiguration
    
    func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview {
        let visiblePath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        let parameters = UIPreviewParameters()
        parameters.visiblePath = visiblePath
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: self, parameters: parameters)
    }
    
    // MARK: - Gestures
    
    func setupGestures() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(pan)
        
        let twoFingerPan = UIPanGestureRecognizer(target: self, action: #selector(didTwoFingerPan))
        twoFingerPan.minimumNumberOfTouches = 2
        twoFingerPan.maximumNumberOfTouches = 2
        twoFingerPan.delaysTouchesBegan = true
        addGestureRecognizer(twoFingerPan)
    }
    
    @objc func didPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case.changed:
            break
        case .ended:
            delegate?.nodePanEnded(self, location: gesture.location(in: superview))
        default:
            break
        }
    }
    
    @objc func didTwoFingerPan(gesture: UIPanGestureRecognizer) {
        guard gesture.numberOfTouches == 2 else { return }
        
        switch gesture.state {
        case .began:
            superview?.bringSubviewToFront(self)
        case .changed:
            center = gesture.location(in: superview)
            lines.forEach({ $0.update() })
        default:
            break
        }
    }
    
    @objc func didDoubleTap() {
        delegate?.nodeDoubleTapped(self)
    }
}
