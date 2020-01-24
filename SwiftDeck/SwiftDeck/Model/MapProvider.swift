//
//  MapProvider.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 20/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// Represents a single map provider on top of which layers can be rendered.
public enum MapProvider: Encodable {

    /// Mapbox-based maps, initialized with a user-specific `key`.
    case mapbox(key: String)

    // MARK: - Encodable implementation

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .mapbox(key):
            try container.encode(key, forKey: .mapboxKey)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case mapboxKey
    }

}

/// Represents the style of the map to be used for rendering.
/// For available styles see For available styles see https://docs.mapbox.com/studio-manual/reference/styles/
// TODO: Customize on per-provider basis
public enum MapStyle: Encodable {

    case none, light, dark, custom(url: String)

    private var url: String? {
        switch self {
        case .none: return nil
        case .light: return "mapbox://styles/mapbox/light-v9"
        case .dark: return "mapbox://styles/mapbox/dark-v9"
        case let .custom(url): return url
        }
    }

    // MARK: - Encodable implementationod

    public func encode(to encoder: Encoder) throws {
        if let url = url {
            var container = encoder.singleValueContainer()
            try container.encode(url)
        }
    }

}
