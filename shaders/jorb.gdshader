shader_type canvas_item;
uniform vec2 offset;
uniform sampler2D sphere_tex : filter_nearest;

void vertex() {

	// Called for every vertex the material is visible on.
}

float curvature(float f) {
	return 0.5 + sin(f * PI) * 1.6;
}
float curve(float f, float uv) {
	return (f - 0.5) / curvature(uv) + 0.5;
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
	return uv - vec2(0.5) * scale + vec2(0.5) * scale;
}

void fragment() {
	vec2 uv = scale_uv(UV, 0.4);
	uv.x = curve(uv.x, UV.x);
	uv.y = curve(uv.y, UV.y);
	uv += offset;
	COLOR *= texture(sphere_tex, wrap_uv(uv));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
