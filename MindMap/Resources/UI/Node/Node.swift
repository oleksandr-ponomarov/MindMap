
import UIKit

final class Node: NSObject, Codable {

    var identifire: String = UUID().uuidString
    var name: String
    var centerPosition: CGPoint
    
    private (set) var children: [Node] = []
    weak var parent: Node?
    
    override var description: String {
        var text = "\(name)"
        if !children.isEmpty {
            text += " [" + children.map { $0.description }.joined(separator: ", ") + "] "
        }
        return text
    }
    
    init(name: String, centerPosition: CGPoint) {
        self.name = name
        self.centerPosition = centerPosition
    }
    
    func add(child: Node) {
        children.append(child)
        child.parent = self
    }
    
    func search(id: String) -> Node? {
        if let node = children.filter({ $0.identifire == id }).first {
            return node
        }
        if id == self.identifire {
            return self
        }
        for child in children {
            if let found = child.search(id: identifire) {
                return found
            }
        }
        return nil
    }
    
    func remove(node: Node) {
        guard let nodeToDelete = search(id: node.identifire),
              let parentNodeToDelete = nodeToDelete.parent else { return }
        
        parentNodeToDelete.children.removeAll { $0 == nodeToDelete }
    }
    
    func depthOfNode(id: String) -> Int {
        var result = 0
        var node = search(id: id)
        
        while node?.parent != nil {
            result += 2
            node = node?.parent
        }
        return result
    }
    
    func forEachDepthFirst(visit: (Node) -> Void) {
        visit(self)
        children.forEach { $0.forEachDepthFirst(visit: visit) }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case children
        case centerPosition
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(centerPosition, forKey: .centerPosition)
        try container.encode(children, forKey: .children)
    }
}
