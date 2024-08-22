// The Swift Programming Language
// https://docs.swift.org/swift-book

import DiscordBM
import Foundation
import SQLite


@main
struct EntryPoint {
    static func main() async throws {
        do {
            let _ = try await Botany()
        } catch let err {
            print(err)
        }
        
    }
}
