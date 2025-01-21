shader_type canvas_item;

uniform int x_pixel_size : hint_range(1, 100);
uniform int y_pixel_size : hint_range(1, 100);

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	vec2 correction = SCREEN_PIXEL_SIZE * vec2(float(x_pixel_size), float(y_pixel_size)) / vec2(2.0);
	vec2 texture_uv = floor(SCREEN_UV / SCREEN_PIXEL_SIZE);
	vec2 offset = vec2(float(int(texture_uv.x) % x_pixel_size), float(int(texture_uv.y) % y_pixel_size));
	vec2 target = (texture_uv - offset) * SCREEN_PIXEL_SIZE;
	//COLOR = texture(screen_texture, SCREEN_UV);
	COLOR = texture(screen_texture, target + correction );
}