shader_type spatial;

uniform vec3 base_color;
uniform float uv_scale = 2.0;
uniform sampler2D noise;

const float min_pattern_spacing = 0.01;
const float spacing_delta = 1.0; // no. of metres for pattern spacing to double

varying vec3 vert_pos;

void vertex() {
	vert_pos = VERTEX;
}

void fragment() {
	ALBEDO = base_color * (0.6 + 0.4 * texture(noise, UV).x);
	SSS_STRENGTH = 0.1;
	ROUGHNESS = 1.0;
	METALLIC = 0.0;
	
	float dist_to_cam = distance(vert_pos, CAMERA_POSITION_WORLD);

	float pattern_spacing = min_pattern_spacing;
	
	vec2 uv_pos = UV * uv_scale * vec2(1,-1);
	vec2 pos = mod(uv_pos, pattern_spacing)/pattern_spacing;
	if (abs(pos.x - 0.5) <= 0.25) {
		float d = abs(pos.x - 0.5);
		float z = sqrt(0.25 * 0.25 - d * d);
		NORMAL_MAP.xz = 0.5 + 1.0 * vec2(pos.x - 0.5, z);
		ROUGHNESS = 0.4 + 0.6 * (0.5 + d);
	} else if (abs(pos.y - 0.5) <= 0.25) {
		float d = abs(pos.y - 0.5);
		float z = sqrt(0.25 * 0.25 - d * d);
		NORMAL_MAP.yz = 0.5 + 1.0 * vec2(pos.y - 0.5, z);
		ROUGHNESS = 0.4 + 0.6 * (0.5 + d);
	}
}
