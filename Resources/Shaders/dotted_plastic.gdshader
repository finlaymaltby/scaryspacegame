shader_type spatial;


uniform vec3 base_color;
// width of the uv in metres
uniform float uv_scale = 2.0;
// spacing of dot ridges
uniform float dot_spacing = 0.015;
uniform float dot_radius = 0.005;

const float lod_bias = 1000.0;

void fragment() {
	ALBEDO = base_color;
	METALLIC = 0.0;
	ROUGHNESS = 0.8;

	vec2 uv_pos = UV * uv_scale;
	uv_pos.y = -uv_pos.y; // becaues godot
	vec2 pos = mod(uv_pos, dot_spacing) / (2.0 * dot_radius);

	float my_lod = length(fwidth(UV)) * lod_bias;

	vec2 r = (pos - vec2(0.5, 0.5));
	if (distance(pos, vec2(0.5, 0.5)) <= 0.5) {
		float z = sqrt(0.25 - r.x * r.x - r.y * r.y);

		vec3 normal_local = normalize(vec3(r, z));
        NORMAL_MAP = (normal_local * 0.5) + 0.5;
		ROUGHNESS += 0.2 / (1.0 + my_lod);
	}
	NORMAL_MAP = normalize(NORMAL_MAP + my_lod * vec3(1,1,1));
}
