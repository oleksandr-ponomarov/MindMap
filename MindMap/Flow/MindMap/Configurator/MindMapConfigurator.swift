
import Foundation

protocol MindMapConfiguratorType {
    func configure(viewController: MindMapViewController)
}

class MindMapConfigurator: MindMapConfiguratorType {
    
    private let mapsListEntity: MapsListEntity
    
    // MARK: - Protocol property
    
    init(with mapsListEntity: MapsListEntity) {
        self.mapsListEntity = mapsListEntity
    }
    
    // MARK: - Protocol method
    
    func configure(viewController: MindMapViewController) {
        let interactor = MindMapInteractor(mapsListEntity: mapsListEntity)
        let router = MindMapRouter(viewController: viewController)
        let presenter = MindMapPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
    }
}
