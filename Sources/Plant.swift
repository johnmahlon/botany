//
//  File.swift
//  
//
//  Created by John Peden on 8/19/24.
//

import Foundation
import DiscordBM
import SQLite

public enum PlantStage: Int {
    case seed = 0
    case seeding = 1
    case baby = 2
    case teen = 3
    case adult = 4
}

public enum PlantSpecies: String, CaseIterable {
    case agave
    case aloe
    case baobab
    case brugmansia
    case cactus
    case columbine
    case daffodil
    case fern
    case ficus
    case flytrap
    case hemp
    case iris
    case jadeplant
    case lithops
    case moss
    case pachypodium
    case palm
    case pansy
    case poppy
    case sage
    case snapdragon
    case sunflower
    
    func getArt(stage: PlantStage) -> String {
        switch stage {
        case .seed: "seed"
        case .seeding: "seedling"
        case .baby: self.rawValue + "1"
        case .teen: self.rawValue + "2"
        case .adult: self.rawValue + "3"
        }
    }
}

enum Mutation: String, CaseIterable {
    case none = ""
    case humming
    case noxious
    case vorpal
    case glowing
    case electric
    case icy
    case flaming
    case psychic
    case screaming
    case chaotic
    case hissing
    case gelatinous
    case deformed
    case shaggy
    case scaly
    case depressed
    case anxious
    case metallic
    case glossy
    case psychedelic
    case bonsai
    case foamy
    case singing
    case fractal
    case crunchy
    case goth
    case oozing
    case stinky
    case aromatic
    case juicy
    case smug
    case vibrating
    case lithe
    case chalky
    case naive
    case ersatz
    case disco
    case levitating
    case colossal
    case luminous
    case cosmic
    case ethereal
    case cursed
    case buff
    case narcotic
}

struct Plant {
    var species: PlantSpecies = PlantSpecies.allCases.randomElement() ?? .agave
    var stage: PlantStage
    var mutation: Mutation = Mutation.allCases.randomElement() ?? .none
    var owner: UserSnowflake
    var birthday = Date()
    
    struct PlantSchema {
        static let table = Table("plants")
        
        static let id = Expression<Int64>("id")
        static let species = Expression<String>("Species")
        static let stage = Expression<Int64>("Stage")
        static let mutation = Expression<String>("Mutation")
        static let owner = Expression<String>("OwnerID")
        static let birthday = Expression<Date>("Birthday")
        
        static func insert(db: Connection, plant: Plant) throws {
            let insert = Plant.PlantSchema.table.insert(
                species <- plant.species.rawValue,
                stage <- Int64(plant.stage.rawValue),
                mutation <- plant.mutation.rawValue,
                owner <- plant.owner.rawValue,
                birthday <- plant.birthday
            )
            
            try db.run(insert)
        }
        
        static func select(db: Connection, owner: UserSnowflake) throws -> Plant? {
            guard let row = try db.pluck(
                Plant.PlantSchema.table
                    .filter(
                        Plant.PlantSchema.owner == owner.rawValue
                    )
            ) else {
                return nil
            }
            
            return Plant(
                species: PlantSpecies(rawValue: try row.get(species)) ?? .agave,
                stage: PlantStage(rawValue: Int(try row.get(stage))) ?? .seed,
                mutation: Mutation(rawValue: try row.get(mutation)) ?? .none,
                owner: UserSnowflake(stringLiteral: try row.get(Plant.PlantSchema.owner))
            )
        }
    }
    
}

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
