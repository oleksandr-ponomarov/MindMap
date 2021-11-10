
import UIKit

protocol IdeaCloudViewDelegate {
    func didDoubleTap(_ bubble: IdeaView)
}

class IdeaView: UIView {
    
    private var ideaLabel: UILabel = .init()
    private let font: UIFont = .boldSystemFont(ofSize: 30)
    private let borderWidth: CGFloat = 5
    private let borderColor: UIColor = .black
    private let height: CGFloat = 100
    private let wight: CGFloat = 200
    
    var delegate: IdeaCloudViewDelegate?
    
    var ideaText: String {
        return ideaLabel.text ?? ""
    }
    
    convenience init(_ point: CGPoint, ideaText: String) {
        self.init()
        
        let frame = getFrameBy(point: point)
        self.init(frame: frame)
    
        setupLabel(text: ideaText)
        setupGestures()
        configure()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchesCount = event?.touches(for: self.window!)?.count else { return }
        if touchesCount == 2 {
            let trackedTouch = touches.min {
                $0.location(in: self.window).x < $1.location(in: self.window).x
            }
            let topSwipeStartPoint = (trackedTouch?.location(in: window))!
            // Ignore the other touch that had a larger x-value
            self.center = topSwipeStartPoint
        }
    }
    
    func setupIdeaText(text: String?) {
        ideaLabel.text = text
    }
}

// MARK: - Private methods
private extension IdeaView {
    func configure() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = height / 2
        clipsToBounds = true
    }
    
    func setupLabel(text: String) {
        ideaLabel.frame = bounds
        ideaLabel.textAlignment = .center
        ideaLabel.numberOfLines = 3
        ideaLabel.text = text
        ideaLabel.font = font
        self.addSubview(ideaLabel)
    }
    
    func setupGestures() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
    
    @objc func doubleTapAction() {
        delegate?.didDoubleTap(self)
    }
    
    func getFrameBy(point: CGPoint) -> CGRect {
        let x = point.x - (wight / 2)
        let y = point.y - (height / 2)
        return CGRect(x: x, y: y, width: wight, height: height)
    }
}
