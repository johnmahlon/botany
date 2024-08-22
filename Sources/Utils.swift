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

public func readPlant(name: String) throws -> String {
    if let path = Bundle.module.url(forResource: name, withExtension: "txt") {
        return try String(contentsOf: path)
    } else {
        throw ReadPlantError.fileNotFound
    }
}
