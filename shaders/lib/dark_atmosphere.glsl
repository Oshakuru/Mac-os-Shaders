#ifndef METAL_DARK_ATMOSPHERE
#define METAL_DARK_ATMOSPHERE
#include "/lib/sky_background.glsl"
// Palette authored from supplied visual references, in the existing LDR space.
vec3 fantasyHorizon(float day, float twilight) {
    vec3 c = mix(vec3(0.065, 0.075, 0.115), vec3(0.58, 0.56, 0.42), day);
    return mix(c, vec3(0.56, 0.30, 0.19), twilight * 0.92);
}
vec3 fantasySky(vec3 direction, vec3 sunDirection, float day, float twilight, float rain) {
    vec3 zenith = mix(vec3(0.032, 0.042, 0.078), vec3(0.30, 0.31, 0.25), day);
    zenith = mix(zenith, vec3(0.27, 0.19, 0.20), twilight * 0.80);
    float wet = clamp(rain, 0.0, 1.0);
    vec3 warm = mix(vec3(0.86, 0.78, 0.55), vec3(0.82, 0.48, 0.24), twilight);
    vec3 c = metalSkyBackground(direction, sunDirection, fantasyHorizon(day, twilight),
        zenith, warm * 0.65, vec3(0.19, 0.24, 0.36), day, wet);
    float gray = dot(c, vec3(0.2126, 0.7152, 0.0722));
    return mix(c, vec3(gray) * vec3(0.91, 0.96, 1.0) * 0.78, wet * 0.75);
}

#endif
