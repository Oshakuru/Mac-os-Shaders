// Original Metal skybox renderer and cloud mask; no reference-pack assets/code.
// Horizon mapping follows the requested angular reach, independent of terrain far.
uniform sampler2D metalCloudMap;
uniform vec3 cameraPosition;
uniform vec3 skyColor;
uniform float frameTimeCounter;
#include "/lib/daylight.glsl"
vec3 metalSkyboxClouds(vec3 sky) {
    if (isEyeInWater != 0) return sky;
    vec3 ray = normalize(skyDirection);
    float wet = clamp(rainStrength, 0.0, 1.0);
    float horizonFade = clamp((ray.y - 0.1 - wet * 0.2) * (6.0 - wet * 5.0), 0.0, 1.0);
    if (horizonFade <= 0.0 || CLOUD_OPACITY <= 0.0) return sky;
    // Smaller, distinct islands; two samples per layer replace the old depth march.
    // The angular horizon fade above is unchanged.
    vec2 projected = ray.xz / ray.y * 12.0;
    vec2 drift = (cameraPosition.xz + vec2(frameTimeCounter, 0.0)) * 0.0625;
    vec2 firstUV = (projected + drift) / 256.0;
    vec2 upperUV = (projected * 1.7 + drift * 0.72 + vec2(71.0, 43.0)) / 256.0;
    float lowerFront = texture2D(metalCloudMap, firstUV).r;
    float lowerBack = texture2D(metalCloudMap, firstUV - projected * 0.025 / 256.0).r;
    float upperFront = texture2D(metalCloudMap, upperUV).g;
    float upperBack = texture2D(metalCloudMap, upperUV - projected * 0.018 / 256.0).g;
    float lower = smoothstep(0.38, 0.68, max(lowerFront, lowerBack));
    float upper = smoothstep(0.46, 0.74, max(upperFront, upperBack)) * 0.22;
    // Composite layers instead of merging/morphing unrelated cloud masks.
    float coverage = lower + upper * (1.0 - lower);
    float bodyShade = mix(0.82, 1.0, lowerFront);
    float day = daylightFactor(normalize(skySunDirection).y);
    float twilight = twilightFactor(normalize(skySunDirection).y);
    vec3 litCloud = mix(vec3(0.13, 0.17, 0.24), vec3(0.96, 0.97, 1.0), day);
    litCloud = mix(litCloud, vec3(1.0, 0.72, 0.49), twilight * 0.65);
#if VISUAL_STYLE == 1
    litCloud = mix(litCloud, litCloud * vec3(0.66, 0.69, 0.73), DARK_STYLE_STRENGTH);
#elif VISUAL_STYLE == 2
    litCloud = mix(litCloud, litCloud * vec3(1.02, 1.01, 0.94), CARTOON_STRENGTH);
#endif
    litCloud *= bodyShade;
    litCloud = mix(litCloud, mix(fogColor, skyColor, 0.35), wet * 0.65);
    return mix(sky, litCloud, clamp(coverage * horizonFade * CLOUD_OPACITY, 0.0, 1.0));
}
