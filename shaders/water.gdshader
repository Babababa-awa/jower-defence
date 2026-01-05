shader_type canvas_item;

void vertex() {
	UV.x += sin(TIME / 5.0) * 0.1;
	UV.y += cos(TIME / 5.0) * 0.02;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
