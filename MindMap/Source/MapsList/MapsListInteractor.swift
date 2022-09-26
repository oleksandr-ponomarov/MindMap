
import UIKit

protocol MapsListInteractorType {
    var mapFiles: [MapFile] { get set }
    
    func createMapFile(name: String) -> MapFile
}

final class MapsListInteractor: MapsListInteractorType {
    
    // MARK: - Protocol property
    
    var mapFiles: [MapFile] = []
    
    // MARK: - Protocol methods
    
    func createMapFile(name: String) -> MapFile {
        let defaultHeight: Double = 2000
        let defaultWidth: Double = 2000
        let centerPosition = CGPoint(x: defaultWidth / 2, y: defaultHeight / 2)
        let node = Node(name: name, centerPosition: centerPosition)
        let contentViewSize = CGSize(width: defaultWidth, height: defaultHeight)
        let mapFile = MapFile(rootNode: node, contentViewSize: contentViewSize)
        return mapFile
    }
}
