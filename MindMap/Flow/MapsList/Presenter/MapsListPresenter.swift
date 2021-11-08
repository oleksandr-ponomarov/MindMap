
import Foundation

protocol MapsListPresenterType {
    func viewDidLoad()
}

class MapsListPresenter: MapsListPresenterType {
    
    private(set) weak var view: MapsListViewType?
    private(set) var interactor: MapsListInteractorType
    private(set) var router: MapsListRouterType
    
    // MARK: - Protocol property
    
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
}
