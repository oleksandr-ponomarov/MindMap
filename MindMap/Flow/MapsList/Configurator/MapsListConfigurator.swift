
import Foundation

protocol MapsListConfiguratorType {
    func configure(viewController: MapsListViewController)
}

class MapsListConfigurator: MapsListConfiguratorType {
    
    // MARK: - Protocol property
    
    // MARK: - Protocol method
    func configure(viewController: MapsListViewController) {
        let interactor = MapsListInteractor()
        let router = MapsListRouter(viewController: viewController)
        let presenter = MapsListPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
    }
}
