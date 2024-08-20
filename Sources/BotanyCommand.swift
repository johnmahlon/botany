//
//  File.swift
//  
//
//  Created by John Peden on 8/19/24.
//

import Foundation
import DiscordBM

enum BotanyCommand: String, CaseIterable {
    case helloworld
    
    var description: String? {
        switch self {
        case .helloworld:
            return "Says hello, <name>"
        }
    }
    
    var options: [ApplicationCommand.Option]? {
        switch self {
        case .helloworld:
            return [
                ApplicationCommand.Option(
                    type: .string,
                    name: "name",
                    description: "name you want to say hello to"
                )
            ]
        }
    }
}
