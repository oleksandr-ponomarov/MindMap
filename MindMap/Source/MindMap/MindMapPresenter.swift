
import Foundation

protocol MindMapPresenterType {
    var mapFile: MapFile { get }
}

final class MindMapPresenter: MindMapPresenterType {
    
    private weak var view: MindMapViewType?
    private var interactor: MindMapInteractorType
    private var router: MindMapRouterType
    
    // MARK: - Protocol property
    
    var mapFile: MapFile {
        interactor.mapFile
    }
    
    init(view: MindMapViewType,
         interactor: MindMapInteractorType,
         router: MindMapRouterType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Protocolol methods

}
