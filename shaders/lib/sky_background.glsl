#ifndef METAL_SKY_BACKGROUND
#define METAL_SKY_BACKGROUND
// Original Metal implementation: broad celestial diffusion and lower-sky falloff.
// Reference: Super Duper Vanilla's sky presentation; no source/assets copied.
vec3 metalSkyBackground(vec3 direction, vec3 sunDirection, vec3 horizonColor,
    vec3 zenithColor, vec3 sunColor, vec3 moonColor, float day, float rain) {
    vec3 ray = normalize(direction);
    float height = smoothstep(0.0, 0.85, max(ray.y, 0.0));
    vec3 color = mix(horizonColor, zenithColor, height);
    float facing = dot(ray, normalize(sunDirection));
    // A broad halo instead of the previous small, concentrated highlight.
    float forward = max(facing, 0.0);
    float backward = max(-facing, 0.0);
    float broadSun = forward * forward;
    float broadMoon = backward * backward;
    float verticalSoftness = 1.0 - abs(ray.y) * 0.45;
    float clear = 1.0 - clamp(rain, 0.0, 1.0);
    color += sunColor * broadSun * verticalSoftness * day * clear * 0.24;
    color += moonColor * broadMoon * verticalSoftness * (1.0 - day) * clear * 0.18;
    float below = min(ray.y, 0.0);
    color *= exp2(-below * below * 8.0);
    return color;
}
#endif
