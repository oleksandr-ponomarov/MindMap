//  
//  MindMapRouter.swift
//  MindMap
//
//  Created by Aleksandr on 09.11.2021.
//

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
