
import UIKit

protocol IdeaCloudViewDelegate {
    func didDoubleTap(_ bubble: IdeaView)
    func didChange()
}

class IdeaView: UIView {
    
    var uuid = UUID().uuidString
    var lines = [LineView]()
    
    private let font: UIFont = .boldSystemFont(ofSize: 30)
    private let borderWidth: CGFloat = 5
    private let borderColor: UIColor = .black
    private let height: CGFloat = 100
    private let minWight: CGFloat = 200
    private let maxWight: CGFloat = 500
    private let padding: CGFloat = 10
    
    private var ideaLabel: UILabel = .init()
    private var secondIdea: IdeaView?
    
    var data: [String: String] {
        var data = [String: String]()
        data["uuid"] = uuid
        data["center"] = NSCoder.string(for: center)
        data["text"] = ideaLabel.text ?? ""
        return data
    }
    
    var delegate: IdeaCloudViewDelegate?
    
    var ideaText: String {
        return ideaLabel.text ?? ""
    }
    
    init(_ point: CGPoint, ideaText: String) {
        let frame = CGRect(x: point.x - (minWight / 2),
                           y: point.y - (height / 2),
                           width: minWight,
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
        guard let touchesCount = event?.touches(for: self.superview!)?.count else { return }
        
        let trackedTouch = touches.min { $0.location(in: self.superview).x < $1.location(in: self.superview).x }
        let topSwipeStartPoint = (trackedTouch?.location(in: superview))!
        if touchesCount == 2 {
            self.center = topSwipeStartPoint
        }
        for line in lines {
            line.update()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchesCount = event?.touches(for: self.superview!)?.count else { return }
        
        let trackedTouch = touches.min { $0.location(in: self.superview).x < $1.location(in: self.superview).x }
        let topSwipeStartPoint = (trackedTouch?.location(in: superview))!
        
        if touchesCount == 1 && !frame.contains(topSwipeStartPoint) {
            secondIdea = IdeaView(topSwipeStartPoint, ideaText: "SecondText")
            guard let secondIdea = secondIdea else { return }
            
            superview?.addSubview(secondIdea)
            let line = LineView(from: self, to: secondIdea)
            superview!.insertSubview(line, at: 0)
        }
        delegate?.didChange()
    }
    
    func setupIdeaText(text: String?) {
        ideaLabel.text = text
        updateFrame()
        delegate?.didChange()
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
        ideaLabel.numberOfLines = 2
        ideaLabel.text = text
        ideaLabel.font = font
        self.addSubview(ideaLabel)
    }
    
    func updateFrame() {
        let labelSize = ideaLabel.sizeThatFits(
            CGSize(width: maxWight - padding * 2, height: height - padding * 2))
        let viewWidth = max(minWight, labelSize.width + padding * 2)
        
        ideaLabel.frame = CGRect(x: padding,
                                 y: padding,
                                 width: viewWidth - padding * 2,
                                 height: height - padding * 2)
        frame = CGRect(x: center.x - (viewWidth / 2),
                       y: center.y - (height / 2),
                       width: viewWidth,
                       height: height)
        setNeedsDisplay()
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
