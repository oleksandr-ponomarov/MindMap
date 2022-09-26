
import UIKit

struct MapFile: Codable {
    
    var rootNode: Node
    var contentViewSize: CGSize
    
    private enum CodingKeys: String, CodingKey {
        case rootNode, contentViewSize
    }
    
    init(rootNode: Node, contentViewSize: CGSize) {
        self.rootNode = rootNode
        self.contentViewSize = contentViewSize
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rootNode = try values.decode(Node.self, forKey: .rootNode)
        contentViewSize = try values.decode(CGSize.self, forKey: .contentViewSize)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rootNode, forKey: .rootNode)
        try container.encode(contentViewSize, forKey: .contentViewSize)
    }
}
