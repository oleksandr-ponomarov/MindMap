
import Foundation

protocol MapsListPresenterType {
    var numberOfRowsInSection: Int { get }
    func viewDidLoad()
    func didTapMapCell(with indexPath: IndexPath)
    func getCellData(by indexPath: IndexPath) -> String
    func addNewMapAction()
}

class MapsListPresenter: MapsListPresenterType {
    
    private(set) weak var view: MapsListViewType?
    private(set) var interactor: MapsListInteractorType
    private(set) var router: MapsListRouterType
    
    // MARK: - Protocol property
    
    var numberOfRowsInSection: Int {
        return interactor.mapsCount
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
    
    func didTapMapCell(with indexPath: IndexPath) {
        let map = interactor.getMap(by: indexPath)
        router.showMindMapScreen(with: map)
    }
    
    func getCellData(by indexPath: IndexPath) -> String {
        return interactor.getMap(by: indexPath)
    }
    
    func addNewMapAction() {
        router.showAddNewMapAlert { [weak self] mapName in
            guard let self = self else { return }
            self.interactor.createNewMap(by: mapName)
            self.view?.updateUI()
        }
    }
}
