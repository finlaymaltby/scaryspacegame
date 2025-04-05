shader_type spatial;

const float uv_scale = 23.5;
const vec3 base_color = vec3(.57, .5, 0.5);

const float sheet_width = 1.0;
const float sheet_depth = 0.1;

const float max_rough = 1.0;
const float min_rough = 0.8;

void fragment() {
	ALBEDO = base_color;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;

	vec2 uv_pos = UV * uv_scale * vec2(1,-1);
	vec2 pos = mod(uv_pos, sheet_width)/sheet_width;
	// if is a vertical wall
	if (abs(dot((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz, vec3(0, 1, 0))) < 0.1) {
		float a = sheet_depth * 16.0;
		float xp = pos.x * (pos.x - 1.0);
		float yp = pos.y * (pos.y - 1.0);
		float z = a * xp * yp;

		vec3 norm = normalize(vec3(-a*yp*(2.0*pos.x - 1.0), -a*xp*(2.0*pos.y - 1.0), 1));
		NORMAL_MAP = normalize(0.5 + 0.5 * norm);
		//ALBEDO = NORMAL_MAP;

		float t = 16.0 * xp * yp;
		ROUGHNESS = min_rough * t + max_rough * (1.0-t);


	}

}
