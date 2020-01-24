//
//  DynamicCodingKey.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 23/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

/// Utility CodingKey implementation that allows for an arbitrary String value to be used as a key.
struct DynamicCodingKey: CodingKey {

    // MARK: - CodingKey implementation

    let stringValue: String

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        stringValue = ""
        self.intValue = intValue
    }

}
