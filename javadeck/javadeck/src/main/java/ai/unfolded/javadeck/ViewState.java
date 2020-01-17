package ai.unfolded.javadeck;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.Map;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
@JsonInclude(value = JsonInclude.Include.NON_NULL)
public class ViewState {
    private Double longitude;
    private Double latitude;
    private Double zoom;
    private Double minZoom;
    private Double maxZoom;
    private Double pitch;
    private Double bearing;

    private Map<String, Object> args;

    @JsonAnyGetter
    public Map<String, Object> getArgs() {
        return args;
    }
}
