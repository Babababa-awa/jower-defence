shader_type canvas_item;
uniform vec2 offset;
uniform sampler2D sphere_tex : filter_nearest;

void vertex() {

	// Called for every vertex the material is visible on.
}

float curvature(float f, float factor) {
	return 0.5 + sin(f * PI * factor) * 2.0;
}
float curve(float f, float uv) {
	return (f - 0.5) / curvature(uv, 1.0) + 0.5;
}

vec2 wrap_uv(vec2 uv) {
	return mod(uv, vec2(1.0));
}

float sqr(float f){
	return f * f;
}
float circle_dist_sqr(vec2 uv) {
	uv -= vec2(0.5);
	return sqr(uv.x) + sqr(uv.y);
}
vec2 scale_uv(vec2 uv, float scale) {
	return (uv - vec2(0.5)) * scale + (vec2(0.5) * scale);
}

float chord_length(float height) {
	float h = height - 0.5;
    return 2.0 * sqrt(max(1.0 - h*h, 0.0));
}

float scaled_by_chord_length(float x, float y) {
	float fac = chord_length(y);
	return (x - 0.5) / fac + 0.5;
}


void fragment() {
	vec2 uv = scale_uv(UV, 2.5);
	uv.x = curve(uv.x, scaled_by_chord_length(UV.y, UV.x));
	uv.y = curve(uv.y, scaled_by_chord_length(UV.x, UV.y));
	uv += offset / 1.4;

	COLOR *= texture(sphere_tex, wrap_uv(uv));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
