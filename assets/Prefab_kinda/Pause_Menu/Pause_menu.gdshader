shader_type canvas_item;

uniform float intensity : hint_range(0.0, 2.0) = 1.0;
uniform float smoothness : hint_range(0.0, 2.0) = 1.0;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;         // center coordinates (-1..1)
    float dist = length(uv);          // distance from center
    float vig = smoothstep(1.0, smoothness, dist); 
    COLOR = vec4(vignette_color.rgb, vig * intensity);
}