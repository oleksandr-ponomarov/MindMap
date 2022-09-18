
import Foundation
import UIKit

protocol MindMapInteractorType {
    var mapsListEntity: MapsListEntity { get }
    func saveToJson(views: [UIView], uuid: String, mapName: String)
}

class MindMapInteractor: MindMapInteractorType {
    
    private let _mapsListEntity: MapsListEntity
    
    // MARK: - Protocol property
  
    var mapsListEntity: MapsListEntity {
        return _mapsListEntity
    }
    
    init(mapsListEntity: MapsListEntity) {
        self._mapsListEntity = mapsListEntity
    }
    
    // MARK: - Protocol methods
    func saveToJson(views: [UIView], uuid: String, mapName: String) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent("\(uuid).json")
        
        var ideas = [[String: String]]()
        var lines = [[String: String]]()
        
        for view in views {
            if view.isKind(of: IdeaView.self) {
                guard let ideaView = view as? IdeaView else { return }
                ideas.append(ideaView.data)
            } else if view.isKind(of: LineView.self) {
                guard let lineView = view as? LineView else { return }
                lines.append(lineView.data)
            }
        }

        let personArray: [String : Any] =  ["ideas": ideas, "lines": lines, "title": mapName]

        let data = try? JSONSerialization.data(withJSONObject: personArray, options: [])
        try? data?.write(to: fileUrl, options: [])
    }
}
