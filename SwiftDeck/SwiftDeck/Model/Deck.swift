//
//  Deck.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 20/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// A deck that bundles the map provider together with layer data.
public struct Deck: Encodable {

    // Layers to be rendered on top of the map.
    public let layers: [Layer]

    /// An array of views that will be used to render the layers.
    public let views: [View]

    /// View state that will be used as the initial value.
    public let initialViewState: ViewState?

    /// Map provider to be used for this deck.
    public let mapProvider: MapProvider?

    /// Other arbitrary arguments relevant to this deck. For more information see
    /// https://github.com/uber/deck.gl/blob/master/docs/api-reference/deck.md
    public let otherProperties: [String: Value]?

    /// Ignore the physical resolution, and instead use the canvas size to determine the drawing buffer size.
    /// See https://deck.gl/#/documentation/deckgl-api-reference/deck?section=usedevicepixels-boolean-number-optional-
    private let useDevicePixels = false

    // MARK: - Lifecycle

    /// Initializes a new deck, with the initial set of properties that are passed as arguments.
    ///
    /// - Parameters:
    ///   - layers: An array of layers that this deck should manage.
    ///   - views: An array of views that this deck should render.
    ///   - initialViewState: Initial camera view state.
    ///   - mapProvider: Map provider details, or `nil` if map should not be rendered across any of the `views`.
    ///   - otherProperties: Other properties that this API currently doesn't support, see
    ///     https://github.com/uber/deck.gl/blob/master/docs/api-reference/deck.md
    public init(layers: [Layer], views: [View], initialViewState: ViewState? = nil, mapProvider: MapProvider? = nil,
                otherProperties: [String: Value]? = nil) {
        self.layers = layers
        self.views = views
        self.initialViewState = initialViewState
        self.mapProvider = mapProvider
        self.otherProperties = otherProperties
    }

    // MARK: - Encodable implementation

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(layers, forKey: .layers)
        try container.encode(views, forKey: .views)
        try container.encodeIfPresent(initialViewState, forKey: .initialViewState)
        if let mapProvider = mapProvider {
            try mapProvider.encode(to: encoder)
        }
        try container.encode(useDevicePixels, forKey: .useDevicePixels)

        if let otherProperties = otherProperties {
            var dynamicContainer = encoder.container(keyedBy: DynamicCodingKey.self)
            for (key, value) in otherProperties {
                try dynamicContainer.encode(value, forKey: DynamicCodingKey(stringValue: key))
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case layers, views, initialViewState, useDevicePixels
    }

}
