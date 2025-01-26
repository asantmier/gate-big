shader_type canvas_item;

group_uniforms Quantization;
uniform float quantize_size : hint_range(0,100, 1.0) = 1;
uniform bool handle_scale;
uniform bool handle_subpixels = true;
group_uniforms;

varying mat4 g_model_matrix;
varying mat4 g_world_to_clip;
varying vec2 g_texture_size;
varying vec2 g_vertex;
varying flat vec2 g_flat_vertex;
varying float g_q_size;

float getQuantizeSize(mat4 canvas_matrix) {
    vec2 g_zoom = vec2(length(canvas_matrix[0].xyz), length(canvas_matrix[1].xyz));
    float q_size = quantize_size;

    if (handle_subpixels && g_zoom.x < 1.) {
        q_size = round(quantize_size * (1. / g_zoom.x));
    }

    return q_size;
}

vec4 quantizeScreen(sampler2D in_screen_texture, vec2 in_screen_uv, vec2 in_vertex) {
    if (g_q_size == 0.) {
        return texture(in_screen_texture, in_screen_uv);
    }

    vec2 uv = (g_model_matrix * vec4(in_vertex, 0, 1)).xy;
    uv /= g_q_size;
    uv = floor(uv) + 0.5;
    uv *= g_q_size;
    uv = (g_world_to_clip * vec4(uv, 0, 1)).xy;
    uv = uv * 0.5 + 0.5;
    return texture(in_screen_texture, uv);
}
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
    g_q_size = getQuantizeSize(CANVAS_MATRIX);
    g_model_matrix = MODEL_MATRIX;
    g_world_to_clip = SCREEN_MATRIX * CANVAS_MATRIX;
    g_vertex = VERTEX;
}

void fragment() {
	COLOR = quantizeScreen(SCREEN_TEXTURE, SCREEN_UV, g_vertex);
}
