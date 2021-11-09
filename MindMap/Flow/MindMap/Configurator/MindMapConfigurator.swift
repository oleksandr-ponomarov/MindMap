//  
//  MindMapConfigurator.swift
//  MindMap
//
//  Created by Aleksandr on 09.11.2021.
//

import Foundation

protocol MindMapConfiguratorType {
    func configure(viewController: MindMapViewController)
}

class MindMapConfigurator: MindMapConfiguratorType {
    
    // MARK: - Protocol property
    
    // MARK: - Protocol method
    func configure(viewController: MindMapViewController) {
        let interactor = MindMapInteractor()
        let router = MindMapRouter(viewController: viewController)
        let presenter = MindMapPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
    }
}
