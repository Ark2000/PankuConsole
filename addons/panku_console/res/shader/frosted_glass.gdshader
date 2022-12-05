shader_type canvas_item;

uniform float amount: hint_range(0.0, 5.0);
uniform float noise: hint_range(0.0, 1.0);
uniform float sz: hint_range(0.0, 0.5);
uniform float fancy: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 col1 = textureLod(SCREEN_TEXTURE, SCREEN_UV, amount).rgb;
	vec3 col2 = vec3((sin(UV.x + TIME*1.0) + 1.0)/2.0, (sin(UV.y+TIME*1.5))/2.0,(sin(UV.x * UV.y + TIME*2.0)+1.0)/2.0);
	float m = step(fract((sz / SCREEN_PIXEL_SIZE.x)*SCREEN_UV.x), 0.5) * step(fract((sz / SCREEN_PIXEL_SIZE.y)*SCREEN_UV.y), 0.5);
	col1 = col1 * (m * noise + (1.0 - noise));
	COLOR.rgb = mix(col1, col2, fancy);
}