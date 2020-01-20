package ai.unfolded.javadeck;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.Collections;
import java.util.List;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
@JsonInclude(value = JsonInclude.Include.NON_NULL)
public class Deck {
    @Builder.Default private List<Layer> layers = Collections.emptyList();
    private List<View> views;
    @Builder.Default private String mapStyle = "mapbox://styles/mapbox/dark-v9";
    private List<Object> effects;
    private ViewState initialViewState;
    private String mapboxKey;
    private String description;

    public static String function(String f) {
        return "@@=" + f;
    }
}
