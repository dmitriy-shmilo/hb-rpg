shader_type canvas_item;

uniform bool active = true;

void fragment() {
	vec4 prev_color = texture(TEXTURE, UV);
	if (active) {
		COLOR = vec4(1.0, 1.0, 1.0, prev_color.a);
	} else {
		COLOR = prev_color;
	}
}