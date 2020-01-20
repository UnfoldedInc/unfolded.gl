package ai.unfolded.androiddeck;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Value;

@Builder
@Value
@JsonInclude(value = JsonInclude.Include.NON_NULL)
public class DeckWebViewConfig {
    private Boolean showLayerJson;

    @JsonIgnore
    private FrameReadyCallback frameReadyCallback;
    private int frameWidth;
    private int frameHeight;

    private Boolean removeFrameReadyCallback;

    @JsonProperty("onFrameCallback")
    public boolean hasFrameReadyCallback() {
        return frameReadyCallback != null;
    }

    public boolean shouldRemoveFrameReadyCallback() {
        return removeFrameReadyCallback != null && removeFrameReadyCallback.booleanValue();
    }
}
