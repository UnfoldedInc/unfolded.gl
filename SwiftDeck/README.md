# SwiftDeck
> ⚠️ EXPERIMENTAL ⚠️ Swift wrapper around deck.gl
[![Swift Version](https://img.shields.io/badge/Swift-5.0-F16D39.svg?style=flat)](https://swift.org/)

SwiftDeck provides basic API around deck.gl, allowing for easy integration within an iOS, or macOS application. It uses `WKWebView` internally, which embeds the content of a deck.gl-based application within it.

![Example](https://i.imgur.com/OjM7y4H.png)

## Requirements

- iOS 11.0+/macOS 10.13+
- Xcode 11

## Installation

#### CocoaPods - Coming Soon!
You can use [CocoaPods](http://cocoapods.org/) to install `SwiftDeck` by adding it to your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!

pod 'SwiftDeck'
```

#### Manually
1. Download and drop ```SwiftDeck.framework``` in your project.
2. Congratulations!

## Usage example

In order to show Mapbox base maps, you'll need a [Mapbox]([https://www.mapbox.com/](https://www.mapbox.com/)) token, which you'd then pass to `MapProvider.mapbox` like so - `MapProvider.mapbox(token: "[YOUR_TOKEN_HERE]")`.

```swift
import SwiftDeck

let deckGLView = DeckGLView()

let data = Value("https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_110m_admin_1_states_provinces_shp.geojson")
let other = ["filled": Value(true), "stroked": Value(true), "lineWidthMinPixels": Value("2"),
             "getLineColor": Value([255, 100, 100]), "getFillColor": Value([200, 160, 0, 180])]
let layer = Layer(identifier: "geojson-usstates", type: .geoJson, data: data, opacity: 0.4, otherProperties: other)

let view = View(type: .map, mapProvider: .mapbox(token: mapboxToken, style: .light))

let viewState = ViewState(longitude: -100, latitude: 40, zoom: 2.7, pitch: 30, bearing: 30)

let deck = Deck(layers: [layer], views: [view], initialViewState: viewState)

deckGLView.update(with: deck)
```

For additional examples, see `SwiftDeckExamples` project that's bundled and ready to run.

Distributed under a custom license. See [https://github.com/UnfoldedInc/unfolded.gl/blob/master/README.md](https://github.com/UnfoldedInc/unfolded.gl/blob/master/README.md) for more information.