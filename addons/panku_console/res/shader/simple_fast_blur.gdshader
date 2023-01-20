shader_type canvas_item;

uniform float lod:hint_range(0.0, 5.0) = 4.0;
uniform vec4 modulate:source_color = vec4(1.0);

void fragment() {
	vec3 col = textureLod(SCREEN_TEXTURE, SCREEN_UV, lod).rgb;
	COLOR = vec4(mix(col, modulate.rgb, modulate.a), 1.0);
}
