void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // map to [0,1] x [0,1]
    vec2 	uv 			= fragCoord/iResolution.xy;
    float 	aspectRatio = iResolution.x / iResolution.y;

    // map to [-1,1] x [-1,1]
    uv 	= (2.0 * uv - 1.0);
    
    // map to [-aspectRatio,aspectRatio] x [-1,1] to avoid stretching
    uv *= vec2(aspectRatio, 1.0);

	float 	t = (uv.y + 1.0) / 2.0;

	fragColor = vec4((1.0-t)*vec3(1.0, 1.0, 1.0) + t*vec3(0.0, 0.0, 0.0), 1.0);

}