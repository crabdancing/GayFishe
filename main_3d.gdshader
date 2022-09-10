shader_type spatial;

uniform float pivot_factor = 0.8;
uniform float time_factor = 10.0;
uniform float side_to_side_factor = 1.0;
uniform float twist_factor = 1.0;
uniform float wave_factor = 1.0;
uniform float body_length = 2.0;
uniform float mask_black = -1.0;
uniform float mask_white = 1.0;

void vertex() {
	float time = TIME * (0.5 + INSTANCE_CUSTOM.y) * time_factor + 6.28318 * INSTANCE_CUSTOM.x;
	// NOTE: fish MUST be centered on zero for this calculation to work!
	// body tells us how far up the body we are...
	// 0.5 for midway, 1.0 for its head, 0.0 for tail, etc
	float body = (VERTEX.z + body_length * 0.5) / body_length;
	
	float mask = smoothstep(mask_black, mask_white, 1.0 - body);
	
	// Side to side movement
	VERTEX.x += cos(time) * side_to_side_factor;
	
	// Pivot motion
	float pivot_angle = cos(time) * 0.1 * pivot_factor;
	mat2 matrix_pivot = mat2(
		vec2(cos(pivot_angle), -sin(pivot_angle)),
		vec2(sin(pivot_angle),  cos(pivot_angle))
	);
	VERTEX.xz *= matrix_pivot;
	
	// Wave motion
	VERTEX.x += cos(time + body) * mask * wave_factor;
	
	// Twist motion
	float twist_angle = cos(time + body) * 0.3 * twist_factor;
	mat2 matrix_twist = mat2(
		vec2(cos(twist_angle), -sin(twist_angle)),
		vec2(sin(twist_angle), cos(twist_angle))
	);
	VERTEX.xy = mix(VERTEX.xy, matrix_twist * VERTEX.xy, mask);
	
}
