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
    vec2 projected = ray.xz / ray.y * 6.0;
    vec2 drift = (cameraPosition.xz + vec2(frameTimeCounter, 0.0)) * 0.0625;
    float phase = clamp(sin(frameTimeCounter * 0.2) * 0.8 + 0.5, 0.0, 1.0);
    float coverage = 0.0;
    float upperCoverage = 0.0;
    for (int i = 0; i < SKYBOX_CLOUD_STEPS; i++) {
        float depth = (float(i) + 0.5) / float(SKYBOX_CLOUD_STEPS);
        vec2 parallax = projected * (1.0 - depth * 0.08);
        vec2 first = texture2D(metalCloudMap, (parallax + drift) / 256.0).rg;
        vec2 second = texture2D(metalCloudMap, (parallax * 2.0 + drift + vec2(71.0, 43.0)) / 256.0).gr;
        coverage += mix(mix(first.x, first.y, phase), max(first.x, first.y), wet);
        upperCoverage += mix(mix(second.x, second.y, phase), max(second.x, second.y), wet);
    }
    coverage = max(coverage, upperCoverage * 0.25) / float(SKYBOX_CLOUD_STEPS);
    float day = daylightFactor(normalize(skySunDirection).y);
    float twilight = twilightFactor(normalize(skySunDirection).y);
    vec3 litCloud = mix(vec3(0.13, 0.17, 0.24), vec3(0.96, 0.97, 1.0), day);
    litCloud = mix(litCloud, vec3(1.0, 0.72, 0.49), twilight * 0.65);
#if VISUAL_STYLE == 1
    litCloud = mix(litCloud, litCloud * vec3(0.66, 0.69, 0.73), DARK_STYLE_STRENGTH);
#elif VISUAL_STYLE == 2
    litCloud = mix(litCloud, litCloud * vec3(1.02, 1.01, 0.94), CARTOON_STRENGTH);
#endif
    litCloud = mix(litCloud, mix(fogColor, skyColor, 0.35), wet * 0.65);
    return mix(sky, litCloud, clamp(coverage * horizonFade * CLOUD_OPACITY, 0.0, 1.0));
}
