
import Foundation

protocol MapsListInteractorType {
    var mapsCount: Int { get }
    func getMap(by indexPath: IndexPath) -> String
    func createNewMap(by name: String)
}

class MapsListInteractor: MapsListInteractorType {
    
    private var mapsArray: [String] = []
    
    // MARK: - Protocol property
    
    var mapsCount: Int {
        return mapsArray.count
    }
    
    init() {}
    
    // MARK: - Protocol methods
    
    func getMap(by indexPath: IndexPath) -> String {
        return mapsArray[indexPath.row]
    }
    
    func createNewMap(by name: String) {
        mapsArray.append(name)
    }
}
