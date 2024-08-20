//
//  File.swift
//  
//
//  Created by John Peden on 8/19/24.
//

import Foundation
import DiscordBM

enum BotanyCommand: String, CaseIterable {
    case water
    case look
    case harvest
    
    var description: String? {
        switch self {
        case .water:
            return "Water your plant"
        case .look:
            return "Look at yours and others' plants"
        case .harvest:
            return "Harvest your plant so you can start a new one"
        }
    }
    
    var options: [ApplicationCommand.Option]? {
        switch self {
        case .water: return nil
        case .look: return [
            ApplicationCommand.Option(
                type: .user,
                name: "look-user",
                description: "Leave blank to see your plant, otherwise look at another user's plant"
            )
        ]
        case .harvest: return nil
        }
    }
}
