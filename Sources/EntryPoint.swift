// The Swift Programming Language
// https://docs.swift.org/swift-book

import DiscordBM
import Foundation

@main
struct EntryPoint {
    static func main() async throws {
        let bot = await BotGatewayManager(
            token: Secrets.discordKey,
            presence: .init(
                activities: [.init(name: "In the Garden", type: .game)],
                status: .online,
                afk: false
            ),
            intents: [.guildMessages, .messageContent, .guildMembers]
        )
        
        let commands = BotanyCommand.allCases.map { command in
            return Payloads.ApplicationCommandCreate(
                name: command.rawValue,
                description: command.description,
                options: command.options
            )
        }
        
        await bot.connect()
        
        try await bot.client
            .bulkSetApplicationCommands(payload: commands)
            .guardSuccess()
        
        for await event in await bot.events {
            EventHandler(event: event, client: bot.client).handle()
        }
    }
}

struct EventHandler: GatewayEventHandler {
    let event: Gateway.Event
    let client: any DiscordClient
    
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
                
            case .look:
                do {
                    let name = "Agave"
                    let art = try readPlant(name: name.lowercased(), stage: .adult)
                    
                    try await client.updateOriginalInteractionResponse(
                        token: interaction.token,
                        payload: Payloads.EditWebhookMessage(
                            content: "\(interaction.member?.user?.username ?? "")'s Plant",
                            embeds: [
                                Embed(
                                    title: "🌱 Agave 🌱",
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
                
            case .harvest: break
            case .none: break
            }
            
        default: break
        }
    }
}
