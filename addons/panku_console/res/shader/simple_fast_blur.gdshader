shader_type canvas_item;

uniform float lod:hint_range(0.0, 5.0) = 0.0;

void fragment() {
	vec3 col = textureLod(SCREEN_TEXTURE, SCREEN_UV, lod).rgb;
	COLOR = vec4(col, 1.0);
}
