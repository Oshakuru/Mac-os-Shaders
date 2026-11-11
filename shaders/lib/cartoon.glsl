#ifndef METAL_CARTOON
#define METAL_CARTOON
#include "/lib/sky_background.glsl"
// Reference-led storybook palette. Existing sky/final passes, no new samples.
vec3 cartoonHorizon(float day, float twilight) {
    vec3 horizon = mix(vec3(0.045, 0.13, 0.21), vec3(0.71, 0.86, 0.83), day);
    return mix(horizon, vec3(0.98, 0.76, 0.52), twilight * 0.80);
}
vec3 cartoonSky(vec3 direction, vec3 sunDirection, float day, float twilight, float rain) {
    vec3 zenith = mix(vec3(0.018, 0.055, 0.12), vec3(0.15, 0.53, 0.76), day);
    zenith = mix(zenith, vec3(0.37, 0.43, 0.56), twilight * 0.62);
    float wet = clamp(rain, 0.0, 1.0);
    vec3 warm = mix(vec3(1.0, 0.96, 0.82), vec3(1.0, 0.79, 0.51), twilight);
    vec3 c = metalSkyBackground(direction, sunDirection, cartoonHorizon(day, twilight),
        zenith, warm, vec3(0.25, 0.40, 0.65), day, wet);
    float gray = dot(c, vec3(0.2126, 0.7152, 0.0722));
    return mix(c, vec3(gray) * vec3(0.90, 0.97, 1.0) * 0.8, wet * 0.7);
}
vec3 cartoonGrade(vec3 source) {
    vec3 c = clamp(source, 0.0, 1.0);
    float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
    float chroma = max(c.r, max(c.g, c.b)) - min(c.r, min(c.g, c.b));
    c = mix(vec3(luma), c, 1.045 - 0.045 * chroma);
    // Preserve texture variations: no global posterization or halftone.
    float shade = 1.0 - smoothstep(0.08, 0.55, luma);
    c *= mix(vec3(1.0), vec3(0.975, 1.005, 1.035), shade * 0.40);
    // Keep greens natural; terrain-specific restraint is applied before lighting.
    c = clamp(c, 0.0, 1.0);
    c += 0.12 * c * (1.0 - c);
    c = mix(c, c * c * (3.0 - 2.0 * c), 0.08);
    return mix(source, clamp(c, 0.0, 1.0), CARTOON_STRENGTH);
}

#endif
