//
//  ConfigurationMessage.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 22/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// Message type that's used to relay view configuration information.
final class ConfigurationMessage: Message {

    /// Configuration data that should be sent.
    let config: DeckGLViewSettings

    // MARK: - Lifecycle

    /// Initialize a new message with provided `configuration`.
    ///
    /// - Parameter config: Configuration data that should be sent.
    init(_ config: DeckGLViewSettings) {
        self.config = config
    }

    // MARK: - Encodable implementation

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(config, forKey: .config)
    }

    private enum CodingKeys: String, CodingKey {
        case config
    }

}
