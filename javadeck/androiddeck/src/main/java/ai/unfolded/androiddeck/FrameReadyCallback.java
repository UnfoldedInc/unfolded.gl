package ai.unfolded.androiddeck;

import android.webkit.JavascriptInterface;

public interface FrameReadyCallback {
    @JavascriptInterface
    void frameReady(String object);
}
