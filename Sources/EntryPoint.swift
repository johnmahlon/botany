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
            intents: [.guildMessages, .messageContent]
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
            case .helloWorld:
                if let name = applicationCommand.option(named: "name")?.value?.asString {
                    try await client.updateOriginalInteractionResponse(
                        token: interaction.token,
                        payload: Payloads.EditWebhookMessage(
                            content: "A",
                            embeds: [
                                Embed(
                                    title: "B",
                                    description: "C",
                                    timestamp: Date(),
                                    color: .init(value: .random(in: 0 ..< (1 << 24) )),
                                    footer: .init(text: "Footer!"),
                                    author: .init(name: "Authored by DiscordBM!"),
                                    fields: [
                                        .init(name: "field name!", value: "field value!")
                                    ]
                                )
                            ],
                            components: [
                                [
                                    .button(
                                        .init(
                                            label: "Open DiscordBM!",
                                            url: "https://github.com/DiscordBM/DiscordBM"
                                        )
                                    )
                                ]
                            ]
                        )
                    ).guardSuccess()
                }
            case .none: break
            }
            
        default: break
        }
    }
}
