//
//  DeckMessage.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 22/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// Message type that's used to relay deck rendering details.
final class DeckMessage: Message {

    /// Deck data that should be sent.
    let deck: Deck

    // MARK: - Lifecycle

    /// Initialize a new message with provided `deck`.
    ///
    /// - Parameter deck: Deck data that should be sent.
    init(_ deck: Deck) {
        self.deck = deck
    }

    // MARK: - Encodable implementation

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(deck, forKey: .deck)
    }

    private enum CodingKeys: String, CodingKey {
        case deck = "deckmsg"
    }

}
