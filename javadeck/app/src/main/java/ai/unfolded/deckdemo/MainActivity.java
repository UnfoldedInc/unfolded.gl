package ai.unfolded.deckdemo;

import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Matrix;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.ImageView;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import ai.unfolded.androiddeck.DeckGlView;
import ai.unfolded.androiddeck.DeckWebViewConfig;
import ai.unfolded.androiddeck.FrameReadyCallback;
import ai.unfolded.javadeck.Deck;
import ai.unfolded.javadeck.Layer;
import ai.unfolded.javadeck.Layers;
import ai.unfolded.javadeck.ViewState;

import static ai.unfolded.javadeck.Deck.function;

/**
 * Demo activity for Deck.gl on Android that can show the Deck.gl
 * instance in a WebView, or via render-to-bitmap.
 */
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";

    private ImageView imageView;
    private WebView webView;
    private DeckGlView deckGlView;
    private ExecutorService executorService;

    private boolean showLayerJson;
    private boolean enableImageView;
    private volatile boolean terminateAnimation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        executorService = Executors.newSingleThreadExecutor();
        showLayerJson = false;
        enableImageView = false;
        terminateAnimation = false;

        imageView = findViewById(R.id.imageView);
        webView = findViewById(R.id.mainWebView);
        deckGlView = DeckGlView.configure(webView);

        setImageViewEnabled(false);

        Button button = findViewById(R.id.button);
        button.setOnClickListener(v -> executorService.submit(this::runAnimation));

        Button button2 = findViewById(R.id.button2);
        button2.setOnClickListener(v -> {
            enableImageView = !enableImageView;
            setImageViewEnabled(enableImageView);
            terminateAnimation = true;
        });

        Button button3 = findViewById(R.id.button3);
        button3.setOnClickListener(v -> {
            showLayerJson = !showLayerJson;
            try {
                deckGlView.update(DeckWebViewConfig.builder()
                        .showLayerJson(showLayerJson)
                        .build());
            } catch (Exception e) {
                Log.e(TAG, "Failed to toggle json shown", e);
            }
            terminateAnimation = true;
        });

        Button button4 = findViewById(R.id.button4);
        button4.setOnClickListener(v -> {
            deckGlView.getWebView().reload();
            terminateAnimation = true;
        });

        // Forward interactions to the webview so interactivity is preserved.
        imageView.setOnDragListener((v, e) -> webView.onDragEvent(e));
        imageView.setOnTouchListener((v, e) -> webView.onTouchEvent(e));
        imageView.setOnClickListener((v) -> webView.callOnClick());

        imageView.setBackgroundColor(Color.BLACK);
    }

    private void setImageViewEnabled(boolean enable) {
        try {
            setTitle("JavaDeck via " + (enable ? "ImageView" : "WebView"));
            imageView.setVisibility(enable ? View.VISIBLE : View.INVISIBLE);
            deckGlView.getWebView().setVisibility(enable ? View.INVISIBLE : View.VISIBLE);
            if (enable) {
                int orientation = getResources().getConfiguration().orientation;
                int tempW, tempH;
                if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
                    tempW = 400;
                    tempH = 200;
                } else {
                    tempW = 200;
                    tempH = 400;
                }
                final int w = tempW;
                final int h = tempH;
                deckGlView.update(DeckWebViewConfig.builder()
                        .frameWidth(w)
                        .frameHeight(h)
                        .frameReadyCallback(new FrameReadyCallback() {
                            @Override
                            @JavascriptInterface
                            public void frameReady(String dec) {
                                try {
                                    byte[] bytes = dec.getBytes("windows-1252");
                                    Log.i(TAG, "frameReady: " + bytes + " " + bytes.length + " " + w + " " + h + " " + (bytes.length / (w * h)));
                                    Bitmap bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
                                    bmp.copyPixelsFromBuffer(ByteBuffer.wrap(bytes));
                                    Matrix flip = new Matrix();
                                    flip.postScale(1, -1);
                                    Bitmap bmp2 = Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), flip, true);
                                    imageView.post(() -> imageView.setImageBitmap(bmp2));
                                } catch (Exception e) {
                                    Log.e(TAG, "frameReady: failed to decode", e);
                                }
                            }
                        })
                        .build());
            } else {
                deckGlView.update(DeckWebViewConfig.builder()
                        .removeFrameReadyCallback(true)
                        .build());
            }
        } catch (Exception e) {
            Log.e(TAG, "onCreate: ", e);
        }
    }

    private void runAnimation() {
        final String idSuffix = Long.toString(System.currentTimeMillis());
        Deck initialDeck = buildAnimationFrame(idSuffix, true, 0);
        try {
            deckGlView.postUpdate(initialDeck);
        } catch (IOException ioe) {
            Log.e(TAG, "Initial animation frame failed", ioe);
        }
        long loopEndInc = TimeUnit.HOURS.toMillis(1);
        double loopLength = 1800;
        double animationSpeed = 30;
        long startTime = System.currentTimeMillis();
        long endTime = startTime + loopEndInc;
        long currentTime;
        while ((currentTime = System.currentTimeMillis()) < endTime) {
            try {
                double timestamp = currentTime / 1000.0;
                double loopTime = loopLength / animationSpeed;

                double timestep = ((timestamp % loopTime) / loopTime) * loopLength;
                deckGlView.postUpdate(buildAnimationFrame(idSuffix, false, timestep));
                Thread.sleep(16);
                if (terminateAnimation) {
                    break;
                }
            } catch (Exception e) {
                Log.e(TAG, "Animation failed", e);
            }
        }
        terminateAnimation = false;
    }

    private static Deck buildAnimationFrame(String idSuffix, boolean initial, double timestep) {
        Deck.DeckBuilder builder = Deck.builder()
                .description("From https://github.com/uber/deck.gl/blob/8.0-release/examples/website/trips/app.js")
                .views(Collections.singletonList(
                        new ai.unfolded.javadeck.View("MapView", true, "mapbox://styles/mapbox/dark-v9")
                ))
                .layers(Arrays.asList(Layer.builder()
                                .id("ground-" + idSuffix)
                                .type(Layers.POLYGON_LAYER)
                                .data(new double[][][]{{{-74.0, 40.7}, {-74.02, 40.7}, {-74.02, 40.72}, {-74.0, 40.72}}})
                                .args(new HashMap<String, Object>() {{
                                    put("stroked", false);
                                    put("getPolygon", "@@=-");
                                    put("getFillColor", Arrays.asList(0, 0, 0, 0));
                                }})
                                .build(),
                        Layer.builder()
                                .id("trips-" + idSuffix)
                                .type(Layers.TRIPS_LAYER)
                                .dataUrl("https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/trips/trips-v7.json")
                                .args(new HashMap<String, Object>() {{
                                    put("getPath", "@@=path");
                                    put("getTimestamps", function("timestamps"));
                                    put("getColor", function("vendor === 0 ? [253, 128, 93] : [23, 184, 190]"));
                                    put("opacity", 0.3);
                                    put("widthMinPixels", 2);
                                    put("rounded", true);
                                    put("trailLength", 180);
                                    put("currentTime", timestep);
                                    put("shadowEnabled", "false");
                                }})
                                .build(),
                        Layer.builder()
                                .id("buildings-" + idSuffix)
                                .type(Layers.POLYGON_LAYER)
                                .dataUrl("https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/trips/buildings.json")
                                .args(new HashMap<String, Object>() {{
                                    put("extruded", true);
                                    put("wireframe", false);
                                    put("opacity", 0.5);
                                    put("getPolygon", function("polygon"));
                                    put("getElevation", function("height"));
                                    put("getFillColor", Arrays.asList(74, 80, 87));
                                    put("material", new HashMap<String, Object>() {
                                        {
                                            put("ambient", 0.6);
                                            put("diffuse", 0.6);
                                            put("shininess", 32);
                                            put("specularColor", Arrays.asList(60, 64, 70));
                                        }
                                    });
                                }})
                                .build()
                ));
        if (initial) {
            builder = builder
                    .initialViewState(ViewState.builder()
                            .latitude(40.72)
                            .longitude(-74.0)
                            .zoom(10.0)
                            .bearing(0.0)
                            .pitch(45.0)
                            .build()
                    );
        }
        return builder.build();
    }
}
