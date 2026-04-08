float QUADRADOS_TIPO = 10.0;


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2  uv          = fragCoord / iResolution.xy;
    float aspectRatio = iResolution.x / iResolution.y;
    uv = (2.0 * uv - 1.0);
    uv *= vec2(aspectRatio, 1.0);


    float cx = step(0.5, fract( 0.5 * uv.x * QUADRADOS_TIPO));
    float cy = step(0.5, fract( 0.5 * uv.y * QUADRADOS_TIPO)); 

    if(cx == cy){
        fragColor = vec4(vec3(1.0), 1.0);
    } else{
        fragColor = vec4(vec3(0.0), 1.0);
    }
    
}