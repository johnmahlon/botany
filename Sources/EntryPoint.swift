// The Swift Programming Language
// https://docs.swift.org/swift-book

import DiscordBM

@main
struct EntryPoint {
    static func main() async throws {
        let bot = await BotGatewayManager(
            token: "",
            presence: .init(
                activities: [.init(name: "In the Garden", type: .custom)],
                status: .online,
                afk: false
            ),
            intents: [.guildMessages, .messageContent]
        )
        
        Task { await bot.connect() }
        
        for await event in await bot.events {
            EventHandler(event: event, client: bot.client).handle()
        }
    }
}

struct EventHandler: GatewayEventHandler {
    let event: Gateway.Event
    let client: any DiscordClient
    
    func onMessageCreate(_ payload: Gateway.MessageCreate) async throws {
        print("NEW MESSAGE!", payload)
    }
}
