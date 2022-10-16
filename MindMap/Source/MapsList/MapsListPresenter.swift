
import Foundation

protocol MapsListPresenterType {
    var numberOfRowsInSection: Int { get }
    
    func viewDidLoad()
    func didTapMapCell(at indexPath: IndexPath)
    func getCellTitle(at indexPath: IndexPath) -> String
    func addNewMapAction()
}

final class MapsListPresenter: MapsListPresenterType {
    
    private weak var view: MapsListViewType?
    private var interactor: MapsListInteractorType
    private var router: MapsListRouterType
    
    // MARK: - Protocol property
    
    var numberOfRowsInSection: Int {
        return interactor.mapFiles.count
    }
    
    init(view: MapsListViewType,
         interactor: MapsListInteractorType,
         router: MapsListRouterType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Protocolol methods
    func viewDidLoad() {
        
    }
    
    func didTapMapCell(at indexPath: IndexPath) {
        let mapFile = interactor.mapFiles[indexPath.row]
        router.showMindMapScreen(mapFile: mapFile)
    }
    
    func getCellTitle(at indexPath: IndexPath) -> String {
        return interactor.mapFiles[indexPath.row].rootNode.name
    }
    
    func addNewMapAction() {
        router.showAddNewMapAlert { [weak self] mapName in
            guard let self = self,
                  let mapName = mapName,
                  !mapName.isEmpty else { return }
            
            let mapFile = self.interactor.createMapFile(name: mapName)
            self.interactor.mapFiles.append(mapFile)
            self.view?.updateUI()
            self.router.showMindMapScreen(mapFile: mapFile)
        }
    }
}
