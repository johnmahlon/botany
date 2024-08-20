//
//  File.swift
//  
//
//  Created by John Peden on 8/19/24.
//

import Foundation

public enum PlantStage: Int, Codable {
    case seed = 0
    case seeding = 1
    case baby = 2
    case teen = 3
    case adult = 4
}

struct Plant: Codable {
    let name: String
    let stage: PlantStage
}

let plantNames: [String] = [
    "agave", "aloe", "baobab", "brugmansia", "cactus", "columbine", "daffodil", "fern",
    "ficus", "flytrap", "hemp", "iris", "jadeplant", "lithops", "moss",
    "pachypodium", "palm", "pansy", "poppy", "sage",  "snapdragon",
     "sunflower"
]

let otherArt: [String] = [
    "template",
    "bee",
    "jackolantern",
    "moon",
    "seed",
    "seedling",
    "sun",
    "rip"
]
