
import UIKit

final class LineView: UIView {
    
    private let fromView: NodeView
    private let toView: NodeView
    
    init(from: NodeView, to: NodeView) {
        fromView = from
        toView = to
        super.init(frame: CGRect.zero)
        
        backgroundColor = .clear
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 5.0
        UIColor.black.setStroke()
        let origin = fromView.center - frame.origin
        let destination = toView.center - frame.origin
        
        let controlVector = CGPoint(x: (destination.x - origin.x) * 0.5, y: 0)
        path.move(to: origin)
        path.addCurve(to: destination, controlPoint1: origin + controlVector, controlPoint2: destination - controlVector)
        path.stroke()
    }
    
    func update() {
        frame = fromView.frame.union(toView.frame)
        setNeedsDisplay()
    }
}
