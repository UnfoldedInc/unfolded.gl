//
//  ClosedRange+Clamp.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 24/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

import Foundation

extension ClosedRange {

    /// Clamps `value` so that it sits between `lowerBound` and `upperBound`.
    ///
    /// - Parameter value: Value to clamp.
    func clamp(_ value: Bound) -> Bound {
        lowerBound > value ? lowerBound : (upperBound < value ? upperBound : value)
    }

}
