
import UIKit

protocol MindMapRouterType {
    
}

class MindMapRouter: MindMapRouterType {
    
    private weak var viewController: MindMapViewController?
    
    // MARK: - Protocol property
    
    init(viewController: MindMapViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Protocol methods
}
