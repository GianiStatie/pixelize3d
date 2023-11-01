shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D normal_texture : hint_normal_roughness_texture, repeat_disable, filter_nearest;

void fragment() {
    vec3 screen_normal = texture(normal_texture, SCREEN_UV).rgb;
    ALBEDO = screen_normal;
}
