//
//  ViewState.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 20/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// Represents a way to describe a viewpoint within the map.
public struct ViewState: Encodable {

    /// View state longitude.
    public let longitude: Double?

    /// View state latitude.
    public let latitude: Double?

    /// View state zoom level.
    public let zoom: Double?

    /// Minimum map zoom level.
    public let minZoom: Double?

    /// Maximum map zoom level.
    public let maxZoom: Double?

    /// Map pitch.
    public let pitch: Double?

    /// Map bearing.
    public let bearing: Double?

    /// Other arbitrary arguments relevant to this view state. For more information see
    /// https://deck.gl/#/documentation/deckgl-api-reference/views/view?section=viewstate-string-object-optional-
    public let otherProperties: [String: Value]?

    // MARK: - Lifecycle

    /// Initializes a view state with the provided arguments.
    ///
    /// - Parameters:
    ///   - longitude: Longitude coordinate component.
    ///   - latitude: Latitude coordinate component.
    ///   - zoom: Zoom level.
    ///   - minZoom: Minimum zoom level.
    ///   - maxZoom: Maximum zoom level.
    ///   - pitch: Pitch value.
    ///   - bearing: Bearing value.
    ///   - otherProperties: Other properties that this API currently doesn't support, see
    ///     https://deck.gl/#/documentation/deckgl-api-reference/views/view?section=viewstate-string-object-optional-
    public init(longitude: Double? = nil, latitude: Double? = nil, zoom: Double? = nil, minZoom: Double? = nil, maxZoom: Double? = nil,
                pitch: Double? = nil, bearing: Double? = nil, otherProperties: [String: Value]? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.zoom = zoom
        self.minZoom = minZoom
        self.maxZoom = maxZoom
        self.pitch = pitch
        self.bearing = bearing
        self.otherProperties = otherProperties
    }

    // MARK: - Encodable implementation

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(zoom, forKey: .zoom)
        try container.encodeIfPresent(minZoom, forKey: .minZoom)
        try container.encodeIfPresent(maxZoom, forKey: .maxZoom)
        try container.encodeIfPresent(pitch, forKey: .pitch)
        try container.encodeIfPresent(bearing, forKey: .bearing)

        if let otherProperties = otherProperties {
            var dynamicContainer = encoder.container(keyedBy: DynamicCodingKey.self)
            for (key, value) in otherProperties {
                try dynamicContainer.encode(value, forKey: DynamicCodingKey(stringValue: key))
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case longitude, latitude, zoom, minZoom, maxZoom, pitch, bearing
    }

}
