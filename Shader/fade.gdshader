shader_type canvas_item;

uniform float opacity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    tex_color.a *= opacity; // Điều chỉnh độ trong suốt
    COLOR = tex_color;
}
