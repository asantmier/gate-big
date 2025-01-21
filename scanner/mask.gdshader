shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
// https://www.youtube.com/watch?v=y2eLChfaYqw
// https://docs.godotengine.org/en/stable/tutorials/shaders/screen-reading_shaders.html

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR.a = texture(TEXTURE, UV).a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
