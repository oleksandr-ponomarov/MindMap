
import Foundation

protocol MindMapPresenterType {
    var mapFile: MapFile { get }
    
    func didSelect(nodeView: NodeView)
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
    
    // MARK: - Protocol methods

    func didSelect(nodeView: NodeView) {
        router.showEditAlert(nodeView: nodeView)
    }
}
