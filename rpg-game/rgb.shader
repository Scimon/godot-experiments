shader_type canvas_item;

uniform float red_multiple = 1.0;
uniform float green_multiple = 1.0;
uniform float blue_multiple = 1.0;
uniform float max_val = 1.0;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	COLOR = vec4(
		clamp(previous_color.r * red_multiple,0.0,max_val),
		clamp(previous_color.g * green_multiple,0.0,max_val),
		clamp(previous_color.b * blue_multiple, 0.0, max_val),
		previous_color.a);
}