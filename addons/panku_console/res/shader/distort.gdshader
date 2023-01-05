shader_type canvas_item;

uniform sampler2D tex1:repeat_enable;
uniform float distort:hint_range(0.0, 0.1) = 0.01;
uniform float scale:hint_range(0.1, 100.0) = 20.0;
uniform float blur:hint_range(1.0, 5.0) = 1.9;
uniform float darken:hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 col1 = texture(tex1, SCREEN_UV * scale);
	vec2 uv = SCREEN_UV + col1.xz * distort;
	vec4 col2 = textureLod(SCREEN_TEXTURE, uv, blur);
	COLOR = mix(col2, vec4(0.0, 0.0, 0.0, 1.0), darken);
}
