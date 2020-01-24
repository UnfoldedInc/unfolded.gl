//
//  Layer.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 20/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// Represents a single layer that can be overlayed on top of a deck.
public struct Layer: Encodable {

    /// Kind of the layer.
    // TODO: Split these up into subclasses, just like deck.gl
    public enum Kind: String, Encodable {

        case scatterplot = "ScatterplotLayer"
        case geoJson = "GeoJsonLayer"
        case screenGrid = "ScreenGridLayer"

    }

    /// Unique identifier that represents this layer.
    let identifier: String

    /// Layer type.
    let type: Kind

    // swiftlint:disable line_length
    /// Data that this layer should render. This could be either an array of data objects, or an url pointing to a data source.
    /// See https://deck.gl/#/documentation/deckgl-api-reference/layers/layer?section=data-iterable-string-promise-asynciterable-object-optional-
    let data: Value?
    // swiftlint:enable line_length

    /// Opacity of the layer in [0...1] range.
    let opacity: Double

    /// Other arbitrary arguments relevant to this layer. For more information see
    /// https://github.com/uber/deck.gl/blob/master/docs/api-reference/layer.md
    let otherProperties: [String: Value]?

    // MARK: - Lifecycle

    // swiftlint:disable line_length
    /// Initializes a layer with an initial set of passed arguments.
    ///
    /// - Parameters:
    ///   - identifier: Unique layer identifier.
    ///   - type: Type of the layer.
    ///   - data: Data that the layer should show, see https://deck.gl/#/documentation/deckgl-api-reference/layers/layer?section=data-iterable-string-promise-asynciterable-object-optional-
    ///   - opacity: Opacity of this layer in [0...1] range.
    ///   - otherProperties: Other properties that this API currently doesn't support, see
    ///     https://github.com/uber/deck.gl/blob/master/docs/api-reference/deck.md
    public init(identifier: String, type: Kind, data: Value? = nil, opacity: Double = 1.0,
                otherProperties: [String: Value]? = nil) {
        self.identifier = identifier
        self.type = type
        self.data = data
        self.opacity = (0.0...1.0).clamp(opacity)
        self.otherProperties = otherProperties
    }
    // swiftlint:enable line_length

    // MARK: - Encodable implementation

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identifier, forKey: .identifier)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encode(opacity, forKey: .opacity)

        if let otherProperties = otherProperties {
            var dynamicContainer = encoder.container(keyedBy: DynamicCodingKey.self)
            for (key, value) in otherProperties {
                try dynamicContainer.encode(value, forKey: DynamicCodingKey(stringValue: key))
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case identifier = "id", type = "@@type", data, opacity
    }

}
