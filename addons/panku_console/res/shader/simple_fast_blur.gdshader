shader_type canvas_item;

uniform float lod:hint_range(0.0, 5.0) = 0.0;
uniform vec4 modulate:source_color = vec4(1.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

void fragment() {
	vec3 col = textureLod(screen_texture, SCREEN_UV, lod).rgb;
	COLOR = vec4(mix(col, modulate.rgb, modulate.a), 1.0);
}
