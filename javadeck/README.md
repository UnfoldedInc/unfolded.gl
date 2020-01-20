# JavaDeck

Java and Android bindings for Deck.gl.

This project is split into three parts:

* `javadeck` - model classes for the Deck.gl transport protocol, which can be
  used in any JVM language project.
* `androiddeck` - code for interfacing between Android applications and
  Deck.gl.
* `app` - demo Android app.
* `playground` - Fork of the Deck.gl playground application which is run
  in an Android webview and used to implement the Deck.gl renderer.

## Usage

```
WebView webView = ...;
DeckGlView deckGlView = DeckGlView.configure(webView);

Deck newVisualization = Deck.builder()
    .layers(Collections.singletonList(Layer.builder()
        // TODO: Complete the example
        .build()
    ))
    .build()

deckGlView.update(newVisualization);
```

## Development

### Android Studio

Install Android Studio and the Lombok Plugin, then import this directory.

### Gradle

Run:

```
./gradlew assemble
```

