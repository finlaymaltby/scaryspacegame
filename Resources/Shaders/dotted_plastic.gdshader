shader_type spatial;


uniform vec3 base_color;
// width of the uv in metres
uniform float uv_scale = 2.0;
// spacing of dot ridges
uniform float dot_spacing;
uniform float dot_radius;

void fragment() {
	ALBEDO = base_color;
	METALLIC = 0.0;
	ROUGHNESS = 0.8;

	vec2 uv_pos = UV * uv_scale;
	uv_pos.y = -uv_pos.y; // becaues godot
	vec2 pos = mod(uv_pos, dot_spacing) / (2.0 * dot_radius);
	
	vec2 center = vec2(0.5, 0.5);
    float dist = distance(pos, center);
	
	if (dist <= 0.5) {
		float z = sqrt(0.25 - (pos.x - center.x) * (pos.x - center.x) - (pos.y - center.y) * (pos.y - center.y));
		
		vec3 normal_local = normalize(vec3(pos - center, z));
        NORMAL_MAP = (normal_local * 0.5) + 0.5;
		ROUGHNESS = 1.0;
	} 
}
