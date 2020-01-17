package ai.unfolded.javadeck;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.Value;

// TODO: Create Java types for different types of Views
@Value
@JsonInclude(value = JsonInclude.Include.NON_NULL)
@Builder
public class View {
    private String type;
    private Boolean controller;
    private String mapStyle;

    @JsonCreator
    public View(@JsonProperty("@@type") String type,
                @JsonProperty("controller") Boolean controller,
                @JsonProperty("mapStyle") String mapStyle) {
        this.type = type;
        this.controller = controller;
        this.mapStyle = mapStyle;
    }

    @JsonProperty("@@type")
    public String getType() {
        return type;
    }

    @JsonProperty("controller")
    public Boolean getController() {
        return controller;
    }

    @JsonProperty("mapStyle")
    public String getMapStyle() {
        return mapStyle;
    }
}
