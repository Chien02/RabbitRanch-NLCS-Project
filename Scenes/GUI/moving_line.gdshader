shader_type canvas_item;

uniform sampler2D texture_albedo; // texture chính (tiled)
uniform sampler2D texture_mask;   // texture mask (alpha gradient)

uniform float speed = 1.0;

void fragment() {
	vec2 moving_uv = vec2(UV.x - (TIME * speed), UV.y);

	// Lấy màu từ texture chính
	vec4 tex_color = texture(texture_albedo, moving_uv);

	// Lấy alpha từ texture mask (không di chuyển)
	float mask_alpha = texture(texture_mask, UV).a;

	// Áp dụng alpha mask lên color
	COLOR = tex_color * mask_alpha;
}
