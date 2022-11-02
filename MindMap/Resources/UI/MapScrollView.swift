
import UIKit

protocol MapScrollViewDelegate: AnyObject {
    func mapScrollView(_ mapScrollView: MapScrollView, didSelectNodeView nodeView: NodeView)
}

class MapScrollView: UIScrollView {
    
    private var containerView = UIView()
    
    var rootNode: Node?
    var mapFile: MapFile?
    var nodeViews = [NodeView]()
    var lastNode: Node?
    
    weak var mapDelegate: MapScrollViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        center()
    }
    
    func setup(viewSize: CGSize) {
        var newFrame = containerView.frame
        newFrame.size.width = viewSize.width
        newFrame.size.height = viewSize.height
        containerView.frame = newFrame
        
        addSubview(containerView)
        containerView.backgroundColor = .clear
        
        contentSize = viewSize
        
        minimumZoomScale = 0.5
        maximumZoomScale = 2.0
        zoomScale = 1.0
    }
    
    func center() {
        let boundsSize = bounds.size
        var frameToCenter = containerView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        containerView.frame = frameToCenter
    }

    func configureUI(mapFile: MapFile) {
        let viewSize = CGSize(width: mapFile.contentViewSize.width, height: mapFile.contentViewSize.height)
        setup(viewSize: viewSize)
        
        var newFrame = containerView.frame
        newFrame.size.width = mapFile.contentViewSize.width
        newFrame.size.height = mapFile.contentViewSize.height
        containerView.frame = newFrame
        
        self.mapFile = mapFile
        
        rootNode = mapFile.rootNode
        let centerPosition = mapFile.rootNode.centerPosition
        if let rootV = addRootNode(at: centerPosition) {
            addChildUI(node: mapFile.rootNode, parentView: rootV)
        }
        
        layoutIfNeeded()
        let centerOffsetX = (contentSize.width - frame.size.width) / 2
        let centerOffsetY = (contentSize.height - frame.size.height) / 2
        let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
//        let centerPoint = mapFile.rootNode.centerPosition
        
        print("OP: centerOffsetX \(centerOffsetX)")
        print("OP: centerOffsetY \(centerOffsetY)")
        print("OP: contentSize.width \(contentSize.width)")
        print("OP: contentSize.height \(contentSize.height)")
        print("OP: frame.size.width \(frame.size.width)")
        print("OP: frame.size.height \(frame.size.height)")
        
        setContentOffset(centerPoint, animated: true)
    }
    
    func addChildUI(node: Node, parentView: NodeView) {
        if !node.children.isEmpty {
            node.children.forEach { child in
                let parentView = addNodeExternally(parentNodeView: parentView, at: child.centerPosition, childNode: child)
                addChildUI(node: child, parentView: parentView)
            }
        }
    }
    
    func addRootNode(at location: CGPoint) -> NodeView? {
        guard let rootNode = mapFile?.rootNode else { return nil }
        
        self.rootNode = rootNode
        lastNode = rootNode
        
        let rootNodeView = NodeView(position: location, node: rootNode)
        rootNodeView.delegate = self
        containerView.addSubview(rootNodeView)
        nodeViews.append(rootNodeView)
        rootNode.centerPosition = CGPoint(x: location.x, y: location.y)
        print("OP: rootNode.centerPosition \(CGPoint(x: location.x, y: location.y))")
        return rootNodeView
    }
}

// MARK: NodeViewDelegate
extension MapScrollView: NodeViewDelegate {
    func nodePanEnded(_ nodeView: NodeView, location: CGPoint) {
        guard !nodeView.frame.contains(location) else { return }
        
        let childNode = Node(name: "", centerPosition: location)
        nodeView.node.add(child: childNode)
        let childNodeView = drawNode(parentNodeView: nodeView, at: location, childNode: childNode)
        mapDelegate?.mapScrollView(self, didSelectNodeView: childNodeView)
    }
    
    func nodeDoubleTapped(_ nodeView: NodeView) {
        mapDelegate?.mapScrollView(self, didSelectNodeView: nodeView)
    }
    
    func nodeEditTapped(_ nodeView: NodeView) {
        mapDelegate?.mapScrollView(self, didSelectNodeView: nodeView)
    }
    
    func nodeRemoveTapped(_ nodeView: NodeView) {
        guard let rootNode = rootNode else { return }
        
        let node = nodeView.node
        var deletedIds: [String] = []
        node.forEachDepthFirst { deletedIds.append($0.id) }
        rootNode.remove(node: node)
        nodeViews.forEach { nodeView in
            let nodeToDelete = nodeView.node
            if deletedIds.contains(nodeToDelete.id) {
                nodeView.delete()
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension MapScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        center()
    }
}

// MARK: - Private methods
private extension MapScrollView {
    func addNodeExternally(parentNodeView: NodeView, at location: CGPoint, childNode: Node) -> NodeView {
        lastNode = childNode
        return drawNode(parentNodeView: parentNodeView, at: location, childNode: childNode)
    }
    
    @discardableResult
    func drawNode(parentNodeView: NodeView, at location: CGPoint, childNode: Node) -> NodeView {
        let childNodeView = NodeView(position: location, node: childNode)
        childNodeView.delegate = self
        containerView.addSubview(childNodeView)
        nodeViews.append(childNodeView)
        
        let line = LineView(from: parentNodeView, to: childNodeView)
        containerView.insertSubview(line, at: 0)
        parentNodeView.lines.append(line)
        childNodeView.lines.append(line)
        line.update()
        childNode.centerPosition = childNodeView.center
        return childNodeView
    }
}
