
import UIKit

protocol MapsListRouterType {
    
}

class MapsListRouter: MapsListRouterType {
    
    private weak var viewController: MapsListViewController?
    
    // MARK: - Protocol property
    
    init(viewController: MapsListViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Protocol methods
}
