//
//  Value.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 20/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// Type-erasing wrapper for Encodable.
public struct Value: Encodable {

    /// Stored closure that can be used to encode the wrapped value.
    private let _encode: (Encoder) throws -> Void

    // MARK: - Lifecycle

    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }

    // MARK: - Encodable implementation

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }

}
