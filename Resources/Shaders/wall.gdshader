shader_type spatial;
uniform vec3 base_color;
uniform float uv_scale = 23.5;

const float sheet_width = .5;
const float ridge_width = 0.1;
const float ridge_depth = 0.05;
const float sheet_thickness = 0.01;

void fragment() {
	ALBEDO = base_color;
	METALLIC = 0.0;
	ROUGHNESS = 0.9;
	CLEARCOAT = .5;
	CLEARCOAT_ROUGHNESS = 0.8;
	
	vec2 uv_pos = UV * uv_scale * vec2(1,-1);
	vec2 pos = mod(uv_pos, ridge_width)/(ridge_width);
	// if is a vertical wall
	if (abs(dot((INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz, vec3(0, 1, 0))) < 0.1) {
		float a = ridge_depth/(ridge_width);
		
		float z = a * sin(PI * pos.x) * sin(PI * pos.y);
		vec2 tangent = normalize(vec2(1.0, a * PI * cos(PI * pos.x)));
		vec3 normal_local = vec3(-tangent.y, 0, tangent.x);
        NORMAL_MAP = (normal_local * 0.5) + 0.5;
		//ALBEDO.g = sin(TAU * uv_pos.y * sheet_width);
		
		
		
	}
	// Called for every pixel the material is visible on.
}

