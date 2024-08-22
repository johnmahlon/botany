//
//  File.swift
//  
//
//  Created by John Peden on 8/21/24.
//

import Foundation
import DiscordBM
import Foundation
import SQLite

struct EventHandler: GatewayEventHandler {
    let event: Gateway.Event
    let client: any DiscordClient
    let db: Connection
    
    func onInteractionCreate(_ interaction: Interaction) async throws {
        try await client.createInteractionResponse(
            id: interaction.id,
            token: interaction.token,
            payload: .deferredChannelMessageWithSource()
        ).guardSuccess()
        
        switch interaction.data {
        case let .applicationCommand(applicationCommand):
            switch BotanyCommand(rawValue: applicationCommand.name) {
            case .water:
                try await water(interaction: interaction)
                
            case .look:
                try await look(interaction: interaction)
                
            case .harvest: break
            case .none: break
            }
            
        default: break
        }
    }
    
    
    
    private func water(interaction: Interaction) async throws {
        try await client.updateOriginalInteractionResponse(
            token: interaction.token,
            payload: Payloads.EditWebhookMessage(
                content: "thanks, \(interaction.member?.user?.username ?? "")!",
                embeds: [
                    Embed(
                        title: "💦 Water Level 💦",
                        description: "100%",
                        timestamp: Date(),
                        color: .init(value: .random(in: 0 ..< (1 << 24) )),
                        footer: .init(text: "🌱"),
                        author: .init(name: "authored by yannick 'happy birthday predhead' weber")
                    )
                ]
            )
        ).guardSuccess()
    }
    
    private func look(interaction: Interaction) async throws {
        do {
            
            guard let user = interaction.member?.user else {
                return
            }
            
            var artName: String = "template"
            var species = "No Plant :("
            
            // try to get plant
            if let plant = try Plant.PlantSchema.select(db: db, owner: user.id) {
                artName = plant.species.getArt(stage: plant.stage)
                species = plant.species.rawValue
            }
            
            let art = try readPlant(name: artName.lowercased(), stage: .adult)
            
            try await client.updateOriginalInteractionResponse(
                token: interaction.token,
                payload: Payloads.EditWebhookMessage(
                    content: "\(user.username)'s Plant",
                    embeds: [
                        Embed(
                            title: "🌱 \(species) 🌱",
                            description: """
```
\(art)
```
""",
                            timestamp: Date(),
                            color: .init(value: .random(in: 0 ..< (1 << 24) )),
                            footer: .init(text: "🌱"),
                            author: .init(name: "authored by yannick 'happy birthday predhead' weber")
                        )
                    ]
                )
            ).guardSuccess()
            
            
        } catch let err {
            print(err)
        }
    }
}
