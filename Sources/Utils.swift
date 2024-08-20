//
//  File.swift
//  
//
//  Created by John Peden on 8/19/24.
//

import Foundation

public enum ReadPlantError: Error {
    case fileNotFound
}

public func readPlant(name: String, stage: PlantStage) throws -> String {
    var _name = name
    switch stage {
    case .seed:
        _name = "seed"
    case .seeding:
        _name = "seedling"
        
    case .baby:
        _name.append("1")
        
    case .teen:
        _name.append("2")
        
    case .adult:
        _name.append("3")
    }
        
    
    if let path = Bundle.module.url(forResource: "agave3", withExtension: "txt") {
        return try String(contentsOf: path)
    } else {
        throw ReadPlantError.fileNotFound
    }
}
