//
//  View.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 23/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// The View class and its subclasses are used to specify where and how your layers should be rendered. Applications typically
/// instantiate at least one View subclass.
public struct View: Encodable {

    /// Kind of the view.
    // TODO: Split these up into subclasses, just like deck.gl
    public enum Kind: String, Encodable {

        case map = "MapView"

    }

    /// View type.
    public let type: Kind

    /// Provider of the underlying map, if one is needed.
    public let mapProvider: MapProvider?

    /// If `true`, the user will be able to interact with the map.
    public let isInteractionEnabled: Bool

    /// Utility structure that represents a relative frame of the view.
    public struct Frame: Encodable {

        // swiftlint:disable identifier_name

        /// Horizontal component of the origin, in [0-1] range.
        public let x: Double

        /// Vertical component of the origin, in [0-1] range.
        public let y: Double

        /// Width that a view should have, in [0-1] range.
        public let width: Double

        /// Height that a view should have, in [0-1] range.
        public let height: Double

        /// Utility constructor that returns a frame which covers the entire area.
        public static var max: Frame { Frame(x: 0.0, y: 0.0, width: 1.0, height: 1.0) }

        // MARK: - Lifecycle

        /// Initializes a new frame based on provided origin and size parameters.
        ///
        /// - Parameters:
        ///   - x: Horizontal component of the origin, in [0-1] range.
        ///   - y: Vertical component of the origin, in [0-1] range.
        ///   - width: Width that a view should have, in [0-1] range.
        ///   - height: Height that a view should have, in [0-1] range.
        public init(x: Double, y: Double, width: Double, height: Double) {
            self.x = (0.0...1.0).clamp(x)
            self.y = (0.0...1.0).clamp(y)
            self.width = (0.0...1.0).clamp(width)
            self.height = (0.0...1.0).clamp(height)
        }

        // MARK: - Encodable implementation

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode("\(x * 100)%", forKey: .x)
            try container.encode("\(y * 100)%", forKey: .y)
            try container.encode("\(width * 100)%", forKey: .width)
            try container.encode("\(height * 100)%", forKey: .height)
        }

        // swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case x, y, width, height
        }

        // swiftlint:enable identifier_name

    }

    /// Frame that this view should be rendered in.
    public let frame: Frame

    // MARK: - Lifecycle

    /// Initializes a new view using the provided set of properties.
    ///
    /// - Parameters:
    ///   - type: Type of the view.
    ///   - mapProvider: Provider for the underlying map, if one is needed.
    ///   - isInteractionEnabled: Flag indicating whether the user should be able to interact with the map or not.
    ///   - frame: Frame that a view should have.
    public init(type: Kind, mapProvider: MapProvider? = nil, isInteractionEnabled: Bool = true, frame: Frame = .max) {
        self.type = type
        self.mapProvider = mapProvider
        self.isInteractionEnabled = isInteractionEnabled
        self.frame = frame
    }

    // MARK: - Encodable implementation

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        if let mapProvider = mapProvider {
            try mapProvider.encode(to: encoder)
        }
        try container.encode(isInteractionEnabled, forKey: .isInteractionEnabled)

        try frame.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case type = "@@type", isInteractionEnabled = "controller"
    }

}
