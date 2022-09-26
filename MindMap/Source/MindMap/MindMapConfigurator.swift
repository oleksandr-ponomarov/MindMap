
import Foundation

protocol MindMapConfiguratorType {
    func configure(viewController: MindMapViewController)
}

final class MindMapConfigurator: MindMapConfiguratorType {
    
    private let mapFile: MapFile
    
    // MARK: - Protocol property
    
    init(mapFile: MapFile) {
        self.mapFile = mapFile
    }
    
    // MARK: - Protocol method
    
    func configure(viewController: MindMapViewController) {
        let interactor = MindMapInteractor(mapFile: mapFile)
        let router = MindMapRouter(viewController: viewController)
        let presenter = MindMapPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
    }
}
