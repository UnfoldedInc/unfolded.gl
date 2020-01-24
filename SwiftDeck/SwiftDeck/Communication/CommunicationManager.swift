//
//  CommunicationManager.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 22/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

import WebKit

/// Error type that's thrown when a message payload is invalid.
enum InvalidMessageError: LocalizedError {

    case invalidData

    // MARK: - LocalizedError implementation

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return NSLocalizedString("Unable to encode the provided message data", comment: "Invalid message data error message")
        }
    }

}

/// Utility object that handles communication with external resources.
final class CommunicationManager {

    /// Web view that's used internally in order to communicate with external resources.
    private let webView: WKWebView

    private let encoder = JSONEncoder()

    // MARK: - Lifecycle

    /// Initializes a new communication manager, that'll use `webView` in order to communicate with external resources.
    ///
    /// - Parameter webView: Web view that'll be used to communicate with external resources.
    init(webView: WKWebView) {
        self.webView = webView
    }

    // MARK: - Utility methods

    /// Sends a `message` using `webView`, calling `completion` once operation is complete.
    ///
    /// - Parameters:
    ///   - message: Message to send.
    ///   - completion: Closure that'll be called once operation is complete.
    func send(message: Message, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let encodedMessage = try encoder.encode(message)
            guard let messageString = String(data: encodedMessage, encoding: .utf8) else {
                completion(.failure(InvalidMessageError.invalidData))
                return
            }

            webView.evaluateJavaScript("window.postMessage('\(messageString)', '*')") { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }

}
