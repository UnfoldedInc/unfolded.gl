//
//  DeckGLView.swift
//  SwiftDeck
//
//  Created by Ilija Puaca on 20/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

import UIKit
import WebKit

/// View in which the map content will be rendered.
public final class DeckGLView: UIView {

    /// Mutable view configuration.
    public var settings = DeckGLViewSettings() {
        didSet {
            if settings != oldValue { update(with: settings) }
        }
    }

    /// Embedded web view in which web content will be embedded.
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        guard let bundleUrl = Bundle.main.url(forResource: "SwiftDeckResources", withExtension: "bundle"),
              let resourceBundle = Bundle(url: bundleUrl),
              let indexUrl = resourceBundle.url(forResource: "index", withExtension: "html") else {
            print("[SwiftDeck] Failed to initialize DeckGLView due to missing resources")
            return webView
        }

        webView.loadFileURL(indexUrl, allowingReadAccessTo: indexUrl)

        let request = URLRequest(url: indexUrl)
        webView.load(request)

        return webView
    }()

    private lazy var communicationManager = CommunicationManager(webView: webView)

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupWebview()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupWebview()
    }

    private func setupWebview() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)

        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    // MARK: - Utility methods

    /// Updates the current view state so that it shows `deck` data.
    ///
    /// - Parameter deck: Deck to render.
    public func update(with deck: Deck) {
        let message = DeckMessage(deck)
        communicationManager.send(message: message) { result in
            if case let .failure(error) = result {
                print("[SwiftDeck] Deck update failed with \(error.message)")
            }
        }
    }

    /// Updates the view state based on `settings`.
    /// - Parameter settings: New set of settings that the view should use.
    public func update(with settings: DeckGLViewSettings) {
        let message = ConfigurationMessage(settings)
        communicationManager.send(message: message) { result in
            if case let .failure(error) = result {
                print("[SwiftDeck] Config update failed with \(error.message)")
            }
        }
    }

}

/// Exposes configurable properties of the DeckGLView.
public struct DeckGLViewSettings: Encodable, Equatable {

    /// Shows or hides the JSON editor.
    public var showLayerJson = false

}
