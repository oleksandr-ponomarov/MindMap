//  
//  MindMapInteractor.swift
//  MindMap
//
//  Created by Aleksandr on 09.11.2021.
//

import Foundation

protocol MindMapInteractorType {
    var mapName: String { get }
}

class MindMapInteractor: MindMapInteractorType {
    
    private let _mapName: String
    
    // MARK: - Protocol property
  
    var mapName: String {
        return _mapName
    }
    
    init(mapName: String) {
        self._mapName = mapName
    }
    
    // MARK: - Protocol methods
}
