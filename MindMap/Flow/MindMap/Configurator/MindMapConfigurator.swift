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
    
    private let mapName: String
    
    // MARK: - Protocol property
    
    init(mapName: String) {
        self.mapName = mapName
    }
    
    // MARK: - Protocol method
    
    func configure(viewController: MindMapViewController) {
        let interactor = MindMapInteractor(mapName: mapName)
        let router = MindMapRouter(viewController: viewController)
        let presenter = MindMapPresenter(view: viewController, interactor: interactor, router: router)
        viewController.presenter = presenter
    }
}
