//
//  File.swift
//  
//
//  Created by John Peden on 8/21/24.
//

import DiscordBM
import Foundation
import SQLite

class Botany {
    var bot: BotGatewayManager
    var db: Connection
    
    init() async throws {
        db = try Connection("botany.sqlite3")
        
        bot = await BotGatewayManager(
            token: Secrets.discordKey,
            presence: .init(
                activities: [.init(name: "In the Garden", type: .game)],
                status: .online,
                afk: false
            ),
            intents: [.guildMessages, .messageContent, .guildMembers]
        )
        
        setupSQLite()
        try await setupDiscord()
    }
    
    private func setupSQLite() {
        do {
            try db.run(
                Plant.PlantSchema.table.create(ifNotExists: true) { t in
                    t.column(Plant.PlantSchema.id, primaryKey: true)
                    t.column(Plant.PlantSchema.species)
                    t.column(Plant.PlantSchema.stage)
                    t.column(Plant.PlantSchema.mutation)
                    t.column(Plant.PlantSchema.owner)
                    t.column(Plant.PlantSchema.birthday)
                }
            )
        } catch let err {
            print(err)
        }
    }
    
    
    private func setupDiscord() async throws {
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
            EventHandler(event: event, client: bot.client, db: db).handle()
        }
    }
}
