
import UIKit

protocol MindMapRouterType {
    
}

final class MindMapRouter: MindMapRouterType {
    
    private weak var viewController: MindMapViewController?
    
    // MARK: - Protocol property
    
    init(viewController: MindMapViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Protocol methods
}
