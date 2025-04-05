shader_type sky;

uniform sampler2D noise;


// No.  of sky cells that have stars:
const float max_star_threshold = 0.7; // at the equator
const float min_star_threshold = 0.2; // at the poles

const float sky_cells = 130.0;
const float star_size = 0.0015;


float trans(float x) {
	return 2.0/PI * asin(x);
}

float easeinout(float x) {
	return x < 1.0 ? pow((1.0-x),4) * (3.0 - 2.0 * (1.0-x)*(1.0-x)) : 0.0;
}

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(127.1, 311.7))) * 43758.5453);
}

vec3 star_colour(float x) {
	vec3 O = vec3(115, 176, 255)/255.0;
	vec3 B = vec3(170, 191, 255)/255.0;
	vec3 A = vec3(202, 215, 255)/255.0;
	vec3 F = vec3(248, 247, 255)/255.0;
	vec3 G = vec3(255, 244, 234)/255.0;
	vec3 K = vec3(255, 210, 161)/255.0;
	vec3 M = vec3(255, 204, 111)/255.0;

	x = x*x; // make da blue stars more liekly
	switch (int(floor(x*7.0))) {
		case 0:
			return O;
		case 1:
			return B;
		case 2:
			return A;
		case 3:
			return F;
		case 4:
			return G;
		case 5:
			return K;
		case 6:
			return M;

		default:
			return vec3(1.0,0.4, 0.7);
	}
}

void sky() {
	if (AT_CUBEMAP_PASS) {
		COLOR = vec3(0,0,0);
	} else {
		COLOR = vec3(0,0,0);
		vec3 mw_norm = normalize(vec3(-0.1, 1, 0.5));

		// DRAW MW HUE
		vec3 mw_z = normalize(cross(mw_norm, vec3(1,0,0)));
		vec3 mw_x = normalize(cross(mw_norm, mw_z));
		vec3 mw_y = normalize(cross(mw_x, mw_z));
		mat3 mw_trans = transpose(mat3(mw_x, mw_y, mw_z));
		vec3 mw_pos = mw_trans * EYEDIR;


		// DRAW STARS
		vec2 pos_2d = EYEDIR.xz;
		//pos_2d *= vec2(-1,1) * sign(EYEDIR.y); // flip the northern hemisphere
		pos_2d = clamp((trans(length(pos_2d)) * normalize(pos_2d) + 1.0)/2.0,0,1);

		vec2 cell_origin = floor(pos_2d * sky_cells)/sky_cells;
		vec2 cell_pos = mod(pos_2d * sky_cells, 1);
		float r1 = random(cell_origin);
		float r2 = random(1.0 + cell_origin);
		float r3 = random(2.0 + cell_origin);
		float r4 = random(3.0 + cell_origin);
		float r5 = random(4.0 + cell_origin);

		float star_cell_radius = (0.3 + 0.7*pow(r1,10)*r2) * sky_cells * star_size;
		vec2 star_centre = -vec2(0.5, 0.5) + vec2(r1, r2);
		star_centre = sign(star_centre) * sqrt(2.0*abs(star_centre))/2.0;
		star_centre = vec2(0.5, 0.5) + (1.0 - 2.0*star_cell_radius)*star_centre;

		float r = (1.0/star_cell_radius) * distance(cell_pos, star_centre);
		float brightness = r3 * clamp(1.0 - r, 0, 1);
		float star_chance = min_star_threshold - (min_star_threshold - max_star_threshold) * easeinout(abs(mw_pos.y));
		brightness = clamp(brightness * sign(star_chance - r4), 0.0, 1.0);
		COLOR = brightness * star_colour(r5);

	}




}
