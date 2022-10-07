shader_type spatial;
render_mode specular_toon;
uniform float beerFactor = 0.8;
uniform sampler2D height_map;
uniform float scale = 2;
uniform float N = 32.0;

float height(vec2 position){
	return texture(height_map, position/scale).x;
}

void vertex() {
  vec2 pos = VERTEX.xz;
  float k = height(pos);
  float R = height(pos+vec2(1.0/N, 0));
  float B = height(pos+vec2(0, 1.0/N));
  NORMAL = normalize(vec3(2.0*(k-R), 1.0, 2.0*(k-B)));
  if (0.1 != 0.0){
  	VERTEX.y = k;
  }
}

void fragment(){
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.2;
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0-fresnel);
	ALBEDO = vec3(0.01,0.03,0.08) + (0.01 * fresnel);
	if (ALBEDO.r > 0.1 && ALBEDO.r > 0.1 && ALBEDO.r > 0.1){
		ALPHA = 1.0;
	} else {
		float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
		depth = depth * 2.0 - 1.0;
		depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
		depth = depth + VERTEX.z;
		depth = exp(-depth * beerFactor);
		ALPHA = clamp(1.0-depth, 0.0, 1.0);
	}
}