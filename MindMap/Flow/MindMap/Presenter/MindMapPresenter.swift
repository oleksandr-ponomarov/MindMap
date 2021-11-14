
import Foundation
import UIKit

protocol MindMapPresenterType {
    var mapName: String { get }
    var mapUuid: String { get }
    func viewDidLoad()
    func saveIdeas(views: [UIView]?)
}

class MindMapPresenter: MindMapPresenterType {
    
    private(set) weak var view: MindMapViewType?
    private(set) var interactor: MindMapInteractorType
    private(set) var router: MindMapRouterType
    
    // MARK: - Protocol property
    
    var mapName: String {
        return interactor.mapsListEntity.title
    }
    
    var mapUuid: String {
        return interactor.mapsListEntity.uuid
    }
    
    init(view: MindMapViewType,
         interactor: MindMapInteractorType,
         router: MindMapRouterType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Protocolol methods
    func viewDidLoad() {
        
    }
    
    func saveIdeas(views: [UIView]?) {
        guard let views = views else { return }
        
        interactor.saveToJson(views: views, uuid: mapUuid, mapName: mapName)
    }
}
