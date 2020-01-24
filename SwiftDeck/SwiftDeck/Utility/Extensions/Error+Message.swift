//
//  Error+Message.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 22/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

extension Error {

    /// Utility property that extracts the most relevant user-facing message.
    var message: String {
        (self as? LocalizedError)?.errorDescription ?? localizedDescription
    }

}
