package ai.unfolded.androiddeck;

import android.net.Uri;
import android.webkit.JavascriptInterface;
import android.webkit.WebMessage;
import android.webkit.WebView;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;

import ai.unfolded.javadeck.Deck;
import lombok.Value;

/**
 * Wrapper around an Android WebView that accepts Deck.gl
 * model objects and JSON transport protocol.
 *
 * TODO: Could make this extend WebView
 */
public class DeckGlView {
    private static final Uri ANY_TARGET_ORIGIN = Uri.parse("*");

    private final WebView webView;
    private final ObjectMapper objectMapper;

    protected DeckGlView(WebView webView, ObjectMapper objectMapper) {
        this.webView = webView;
        this.objectMapper = objectMapper;
    }

    public static DeckGlView configure(WebView webView) {
        return configure(webView, new ObjectMapper());
    }

    public static DeckGlView configure(WebView webView, ObjectMapper objectMapper) {
        final DeckGlView wrapper = new DeckGlView(webView, objectMapper);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.loadUrl("file:///android_asset/index.html");
        return wrapper;
    }

    public WebView getWebView() {
        return webView;
    }

    public void postUpdate(Deck deck) throws IOException {
        postUpdateJson(objectMapper.writeValueAsString(new DeckStateChange(deck)));
    }

    protected void postUpdateJson(String message) {
        webView.post(() -> updateJson(message));
    }

    public void update(Deck deck) throws IOException {
        updateJson(objectMapper.writeValueAsString(new DeckStateChange(deck)));
    }

    public void update(DeckWebViewConfig config) throws IOException {
        if (config.getFrameReadyCallback() != null) {
            webView.addJavascriptInterface(config.getFrameReadyCallback(), "NATIVE_frameReadyCallback");
            webView.addJavascriptInterface(new FrameSize(config), "NATIVE_frameSize");
            webView.reload();
        } else if (config.shouldRemoveFrameReadyCallback()) {
            webView.removeJavascriptInterface("NATIVE_frameReadyCallback");
            webView.removeJavascriptInterface("NATIVE_frameSize");
            webView.reload();
        }
        updateJson(objectMapper.writeValueAsString(new DeckConfigChange(config)));
    }

    protected void updateJson(String message) {
        webView.postWebMessage(
                new WebMessage(message),
                ANY_TARGET_ORIGIN);
    }

    @Value
    private static class DeckStateChange {
        private Deck deckmsg;
    }

    @Value
    private static class DeckConfigChange {
        private DeckWebViewConfig config;
    }

    private static class FrameSize {
        private final DeckWebViewConfig config;

        FrameSize(DeckWebViewConfig config) {
            this.config = config;
        }

        @JavascriptInterface
        public int frameWidth() {
            return config.getFrameWidth();
        }

        @JavascriptInterface
        public int frameHeight() {
            return config.getFrameHeight();
        }
    }
}
