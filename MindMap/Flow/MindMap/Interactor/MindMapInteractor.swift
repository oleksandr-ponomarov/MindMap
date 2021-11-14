//  
//  MindMapInteractor.swift
//  MindMap
//
//  Created by Aleksandr on 09.11.2021.
//

import Foundation

protocol MindMapInteractorType {
    var mapsListEntity: MapsListEntity { get }
}

class MindMapInteractor: MindMapInteractorType {
    
    private let _mapsListEntity: MapsListEntity
    
    // MARK: - Protocol property
  
    var mapsListEntity: MapsListEntity {
        return _mapsListEntity
    }
    
    init(mapsListEntity: MapsListEntity) {
        self._mapsListEntity = mapsListEntity
    }
    
    // MARK: - Protocol methods
}
