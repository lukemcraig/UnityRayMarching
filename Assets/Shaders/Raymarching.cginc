

/* Primative SDF functions */
float signedSphere(float3 position, float radius) {
	//sqrt(x^2 + y^2 + z^2) - radius
	return length(position) - radius;
}

// there is only one "surface", the scene surface.
float sceneSDF(float3 position) {

	float sphere = signedSphere(position, 0.3);
	return sphere;
}

float rayMarching(float3 rayOrigin, float3 rayDirection, float min, float max) {
	
	float t = min;
	for (int i = 0; i<MAX_MARCHING_STEPS; i++) {
		float dist = sceneSDF(rayOrigin + (t*rayDirection));
		// if the signed distance function evaluates to a negative number
		if (dist < EPSILON) {
			// we are in the scene "surface"
			return t;
		}
		// otherwise move to the next step along the ray
		// the SDF gave us the distance to the surface, so that's why we step that much
		t += dist;

		if (t >= max) {
			// don't march past the max t
			
			return max;
		}
	}	
	return max;
}

