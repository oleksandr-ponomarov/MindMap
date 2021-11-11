
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
    private var secondIdea: IdeaView?
    
    var delegate: IdeaCloudViewDelegate?
    
    var ideaText: String {
        return ideaLabel.text ?? ""
    }
    
    init(_ point: CGPoint, ideaText: String) {
        let frame = CGRect(x: point.x - (wight / 2),
                           y: point.y - (height / 2),
                           width: wight,
                           height: height)
        super.init(frame: frame)
    
        setupLabel(text: ideaText)
        setupGestures()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchesMoved")
        
        guard let touchesCount = event?.touches(for: self.superview!)?.count else { return }
        let trackedTouch = touches.min { $0.location(in: self.superview).x < $1.location(in: self.superview).x }
        let topSwipeStartPoint = (trackedTouch?.location(in: superview))!
        if touchesCount == 2 {
            self.center = topSwipeStartPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("AP: touchesEnded")
        
        guard let touchesCount = event?.touches(for: self.superview!)?.count else { return }
        let trackedTouch = touches.min { $0.location(in: self.superview).x < $1.location(in: self.superview).x }
        let topSwipeStartPoint = (trackedTouch?.location(in: superview))!
        
        if touchesCount == 1 && !frame.contains(topSwipeStartPoint) {
            secondIdea = IdeaView(topSwipeStartPoint, ideaText: "SecondText")
            superview?.addSubview(secondIdea!)
            let line = LineView(from: self, to: secondIdea!)
            superview!.insertSubview(line, at: 0)
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
}
