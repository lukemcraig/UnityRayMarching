

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

float3 labertianShading(float3 normal, float3 lightDirection, float3 diffuse, float3 lightColor) {
	float3 col = lightColor*(dot(normal, lightDirection)*diffuse);
	return clamp(col, 0.0, 1.0);
}

float3 phongShading(float3 normal, float3 lightDirection, float3 diffuse, float3 viewVec, float3 lightColor) {
	float3 lambertian = labertianShading(normal, lightDirection, diffuse, lightColor);
	float3 h = normalize(viewVec + lightDirection);
	float3 specular = float3(1.0, 1.0, 1.0)*pow(max(0, dot(normal, h)), 1000);
	float3 col = lambertian + specular;
	return clamp(col, 0.0, 1.0);
}

float3 calculateLight(float3 color, float3 p, float3 viewVec, float3 normal, float3 aLightPos,  float3 lightColor) {
	float3 lightDirection = normalize(aLightPos - p);

	float lightDistance = length(aLightPos - p);

	//float shadow = rayMarching(p, lightDirection, 0.0001, lightDistance);
	//if (shadow == lightDistance) {
		color += phongShading(normal, lightDirection, float3(1.0,0.0,0.0), viewVec, lightColor);

	//}
	return color;
}

//http://jamie-wong.com/2016/07/15/ray-marching-signed-distance-functions/
float3 estimateNormal(float3 p) {
	return normalize(float3(
		sceneSDF(float3(p.x + EPSILON, p.y, p.z)) - sceneSDF(float3(p.x - EPSILON, p.y, p.z)),
		sceneSDF(float3(p.x, p.y + EPSILON, p.z)) - sceneSDF(float3(p.x, p.y - EPSILON, p.z)),
		sceneSDF(float3(p.x, p.y, p.z + EPSILON)) - sceneSDF(float3(p.x, p.y, p.z - EPSILON))
	));
}

