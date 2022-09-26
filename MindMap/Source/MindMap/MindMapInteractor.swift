
import Foundation

protocol MindMapInteractorType {
    var mapFile: MapFile { get }
}

final class MindMapInteractor: MindMapInteractorType {
    
    // MARK: - Protocol property
    let mapFile: MapFile
    
    init(mapFile: MapFile) {
        self.mapFile = mapFile
    }
    
    // MARK: - Protocol methods

}
