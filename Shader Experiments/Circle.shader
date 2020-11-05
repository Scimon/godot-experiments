shader_type canvas_item;

uniform float radius = 0.4;

void fragment(){
	float dist = ((UV.x - 0.5) * (UV.x-0.5) ) + ((UV.y - 0.5) * (UV.y - 0.5));
	float res = (radius * radius) - dist; 
	res = ceil(res);
	COLOR = vec4(1.0,1.0,1.0,res);
}