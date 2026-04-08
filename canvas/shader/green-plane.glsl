#define INFINITY    16777215.0
#define PI          3.14159265359
#define TWO_PI      6.28318530718
#define PLANE_SIZE  20.0

/// ****************************************************************************
/// Ray structure
/// ****************************************************************************
struct Ray {
	vec3 	O;	// origin of the ray
	vec3 	D;	// direction of the ray

};

/// ****************************************************************************
/// Camera structure
/// ****************************************************************************
struct Camera {
	vec3 	e0, e1, e2;		// basis vectors of the camera: right, up, forward
	vec3	O;			    // the camera origin
	vec3 	lookAt;		  	// the point the camera is looking at
	vec3 	up;		      	// the up vector of the camera
};

/// ****************************************************************************
/// Plane structure
/// ****************************************************************************
struct Plane {
	vec3	normal; 	// plane normal
	float	d;			// plane d parameter in plane equation
	vec3	color;		// plane color
};

/// ****************************************************************************
/// Compute a point along a ray at distance t
/// ****************************************************************************
vec3 at(in Ray ray, in float t) {
 	return ray.O + t * ray.D;  
}

/// ****************************************************************************
/// Plane-ray intersection function
/// ****************************************************************************
float intersect(in Plane p, in Ray ray) {
	float den = dot(ray.D, p.normal);
	if(abs(den) < 0.0001)
		return INFINITY; // no intersection, the ray is parallel to the plane

	float num = -(dot(p.normal, ray.O) + p.d);
	float t = num / den;

	vec3 pto = at(ray, t);
	if (abs(pto.z) > PLANE_SIZE/2.0)	
		return INFINITY;
    
	return t;
}

/// ****************************************************************************
/// Ray generation function
/// ****************************************************************************
Ray generateRay(in Camera cam, in vec2 uv) {
	Ray ray;
	ray.O = cam.O;
	ray.D = normalize(uv.x * cam.e0 + uv.y * cam.e1 + cam.e2);

  return ray;
}

/// ****************************************************************************
/// Camera creation function  
/// ****************************************************************************
Camera criaCamera(vec3 pos, vec3 lookAt, vec3 up) {

    vec3 forward = normalize(lookAt - pos);

    Camera c;
    c.O 		= pos;
    c.lookAt 	= lookAt;
    c.up		= up;
    c.e2		= forward;  // eixo Z (forward)
    c.e0		= normalize(cross(forward, up));  // eixo X (right)
    c.e1		= cross(c.e0, forward);  // eixo Y (up) - já normalizado    
    
    return c;
}

/// ****************************************************************************
/// Background color function
/// ****************************************************************************
vec4 CorDeFundo(vec3 ray) {
	float t = (ray.y + 1.0) / 2.0;
	return vec4((1.0-t)*vec3(1.0, 1.0, 1.0) + t*vec3(0.2, 0.4, 1.0), 1.0);
	}




/// ****************************************************************************
/// ****************************************************************************
/// Main image function
/// ****************************************************************************
/// ****************************************************************************
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
        
    vec2 	uv	    	= fragCoord/iResolution.xy;
    float 	aspectRatio = iResolution.x / iResolution.y;
    uv 	= (2.0 * uv - 1.0);
    uv *= vec2(aspectRatio, 1.0);

    Camera cam = criaCamera(  vec3(0.0, 0.0, 5.0),
                              vec3(0.0, 0.0, 0.0), 
                              vec3(0.0, 1.0, 0.0) );

    Plane plane;
    plane.normal 	  = vec3(0.0, 1.0, 0.0);
    plane.d			  = 5.0;
    plane.color 	  = vec3(0.0, 1.0, 0.0);

    Ray ray 		    = generateRay(cam, uv);
    
    float tPlano 	  = intersect(plane, ray);

	if (tPlano == INFINITY) 
		fragColor = CorDeFundo(ray.D);
	else
    	fragColor = vec4(plane.color, 1.0);
}