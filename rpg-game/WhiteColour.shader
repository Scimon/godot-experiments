shader_type canvas_item;

uniform bool active = true;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 new_color = vec4(
		float(active) + ( previous_color.r * float(!active) ), 
		float(active) + ( previous_color.g * float(!active) ), 
		float(active) + ( previous_color.b * float(!active) ), 
		previous_color.a 
	);
	COLOR = new_color;
}