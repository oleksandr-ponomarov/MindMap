
import Foundation

protocol MapsListInteractorType {
    var mapsCount: Int { get }
    func getMap(by indexPath: IndexPath) -> MapsListEntity
    func createNewMap(by name: String)
}

class MapsListInteractor: MapsListInteractorType {
    
    private var mapsArray: [MapsListEntity] = []
    
    // MARK: - Protocol property
    
    var mapsCount: Int {
        return mapsArray.count
    }
    
    init() {
        
    }
    
    // MARK: - Protocol methods
    
    func getMap(by indexPath: IndexPath) -> MapsListEntity {
        return mapsArray[indexPath.row]
    }
    
    func createNewMap(by name: String) {
        let map = MapsListEntity(title: name, uuid: UUID().uuidString)
        mapsArray.append(map)
    }
}
