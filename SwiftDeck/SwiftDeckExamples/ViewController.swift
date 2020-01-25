//
//  ViewController.swift
//  SwiftDeckExamples
//
//  Created by Ilija Puaca on 21/1/20.
//  Copyright © 2020 Unfolded. All rights reserved.
//

import SwiftDeck
import UIKit

final class ViewController: UIViewController {

    #warning("Enter your Mapbox token here")
    private let mapboxToken = ""

    // MARK: - Example Decks

    private lazy var usStatesDeck: Deck = {
        let data = Value("https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_110m_admin_1_states_provinces_shp.geojson")
        let other = ["filled": Value(true), "stroked": Value(true), "lineWidthMinPixels": Value("2"),
                     "getLineColor": Value([255, 100, 100]), "getFillColor": Value([200, 160, 0, 180])]
        let layer = Layer(identifier: "geojson-usstates", type: .geoJson, data: data, opacity: 0.4, otherProperties: other)

        let view = View(type: .map, mapProvider: .mapbox(token: mapboxToken, style: .light))

        let viewState = ViewState(longitude: -100, latitude: 40, zoom: 2.7, pitch: 30, bearing: 30)

        return Deck(layers: [layer], views: [view], initialViewState: viewState)
    }()

    private lazy var californiaDropoffsDeck: Deck = {
        let data = Value("https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/screen-grid/ca-transit-stops.json")
        let colorRange = [[255, 255, 178, 25], [254, 217, 118, 85], [254, 178, 76, 127], [253, 141, 60, 170], [240, 59, 32, 212],
                          [189, 0, 38, 255]]
        let other = ["cellSizePixels": Value(20), "getPosition": Value("@@=-"), "gpuAggregation": Value(true),
                     "getLineColor": Value([255, 100, 100]), "colorRange": Value(colorRange)]
        let layer = Layer(identifier: "screengrid-california", type: .screenGrid, data: data, opacity: 0.8, otherProperties: other)

        let view = View(type: .map, mapProvider: .mapbox(token: mapboxToken, style: .dark))

        let viewState = ViewState(longitude: -119.3, latitude: 35.6, zoom: 5.3, maxZoom: 20)

        return Deck(layers: [layer], views: [view], initialViewState: viewState)
    }()

    private lazy var newYorkDropoffDeck: Deck = {
        let data = Value("https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/scatterplot/manhattan.json")
        let other = ["radiusScale": Value(30), "radiusMinPixels": Value(0.25), "getPosition": Value("@@=-"),
                     "getFillColor": Value([0, 128, 255]), "getRadius": Value(1)]
        let layer = Layer(identifier: "scatterplot-newyork", type: .scatterplot, data: data, otherProperties: other)

        let view = View(type: .map, mapProvider: .mapbox(token: mapboxToken, style: .light))

        let viewState = ViewState(longitude: -73.97, latitude: 40.76, zoom: 11.65, maxZoom: 16.0)

        return Deck(layers: [layer], views: [view], initialViewState: viewState)
    }()

    // MARK: - Outlets

    @IBOutlet private var deckGLView: DeckGLView! {
        didSet {
            // Set the initial state
            deckGLView.update(with: usStatesDeck)
        }
    }

    // MARK: - User actions

    @IBAction private func onUSStatesTapped(_ sender: Any) {
        deckGLView.update(with: usStatesDeck)
    }

    @IBAction private func onCaliforniaTransitStopsTapped(_ sender: Any) {
        deckGLView.update(with: californiaDropoffsDeck)
    }

    @IBAction private func onNewYorkDropoffsTapped(_ sender: Any) {
        deckGLView.update(with: newYorkDropoffDeck)
    }

    @IBAction private func onToggleJsonEditorTapped(_ sender: Any) {
        deckGLView.settings.showLayerJson.toggle()
    }

}
