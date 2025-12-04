shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 3.0) = 1.0;
uniform float center_glow : hint_range(0.0, 3.0) = 1.0;
uniform float radius : hint_range(0.1, 2.0) = 1.0;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float dist = length(uv);

    float glow = smoothstep(radius, 0.0, dist);
    glow *= glow_strength;

    float center_boost = (1.0 - dist) * center_glow;

    COLOR = vec4(vec3(glow + center_boost), glow);
}