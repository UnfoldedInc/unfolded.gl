package ai.unfolded.javadeck;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonValue;

import java.util.Map;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

// TODO: Create classes for GeoJsonLayer, etc.
@Value
@Builder
@JsonInclude(value = JsonInclude.Include.NON_NULL)
public class Layer {
    private String type;
    @Builder.Default
    private String id = UUID.randomUUID().toString();

    private Object data;
    private String dataUrl; // TODO support different types

    private Map<String, Object> args;

    @JsonProperty("@@type")
    public String getType() {
        return type;
    }

    @JsonProperty("id")
    public String getId() {
        return id;
    }

    @JsonProperty("data")
    public Object getData() {
        if (data != null) {
            return data;
        } else if (dataUrl != null) {
            return dataUrl;
        }

        return null;
    }

    @JsonAnyGetter
    public Map<String, Object> getArgs() {
        return args;
    }
}
