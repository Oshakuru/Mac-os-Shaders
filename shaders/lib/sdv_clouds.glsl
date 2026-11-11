// Adapted from Super Duper Vanilla v1.3.8 — Eldeston / FlameRender (C) Studios.
// Copyright (C) 2023 Eldeston. FlameRender (C) Studios License v1.6.
// This file and the SDV cloud texture retain that license; not relicensed GPL.
// Modified for Metal: GLSL 120 sampling, preset cloud tones and bounded LDR compositing.
uniform sampler2D sdvCloudMap;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;
#include "/lib/daylight.glsl"
vec2 sdvCloudParallax(vec2 start, vec2 cameraPos) {
    vec2 end = start * (0.08 / float(SDV_CLOUD_STEPS));
    start += cameraPos * 0.0625;
    vec2 cloudData = vec2(0.0);
    for (int i = 1; i <= SDV_CLOUD_STEPS; i++) {
        // Equivalent to the source's texelFetch(ivec2(start) & 255, 0).
        vec2 cell = vec2(ivec2(start));
        vec2 cloudMap = texture2D(sdvCloudMap, (mod(cell, 256.0) + 0.5) / 256.0).rg;
        if (cloudMap.x > 0.5) cloudData.x = float(i);
        if (cloudMap.y > 0.5) cloudData.y = float(i);
        start -= end;
    }
    return cloudData;
}
vec3 metalSDVClouds(vec3 sky) {
    if (isEyeInWater != 0) return sky;
    vec3 ray = normalize(skyDirection);
    float wet = clamp(rainStrength, 0.0, 1.0);
    float heightFade = (ray.y - 0.1 - wet * 0.2) * (6.0 - wet * 5.0);
    if (heightFade <= 0.0 || CLOUD_OPACITY <= 0.0) return sky;
    heightFade = min(heightFade, 1.0);
    vec2 planeUV = ray.xz * (6.0 / ray.y);
    vec2 planePos = vec2(cameraPosition.x + frameTimeCounter, cameraPosition.z);
    vec2 data = sdvCloudParallax(planeUV, planePos);
    data = max(sdvCloudParallax(planeUV * 2.0, planePos).yx * 0.25, data);
    float fadeTime = clamp(sin(frameTimeCounter * 0.20) * 0.8 + 0.5, 0.0, 1.0);
    float clouds = mix(mix(data.x, data.y, fadeTime), max(data.x, data.y), wet);
    clouds *= heightFade / float(SDV_CLOUD_STEPS);
    float day = daylightFactor(normalize(skySunDirection).y);
    float twilight = twilightFactor(normalize(skySunDirection).y);
    vec3 cloudTone = mix(vec3(0.15, 0.19, 0.28), vec3(0.96, 0.97, 1.0), day);
    cloudTone = mix(cloudTone, vec3(1.0, 0.73, 0.51), twilight * 0.65);
#if VISUAL_STYLE == 1
    cloudTone *= mix(vec3(1.0), vec3(0.66, 0.69, 0.73), DARK_STYLE_STRENGTH);
#elif VISUAL_STYLE == 2
    cloudTone *= mix(vec3(1.0), vec3(1.02, 1.01, 0.94), CARTOON_STRENGTH);
#endif
    cloudTone = mix(cloudTone, fogColor, wet * 0.55);
    return mix(sky, cloudTone, clamp(clouds * CLOUD_OPACITY, 0.0, 1.0));
}
