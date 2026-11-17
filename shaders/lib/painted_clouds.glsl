// Miyazaki Skybox: one read of a pixel-art cloud panorama (textures/painted/clouds.png,
// original macOS Shaders art, premultiplied white). Tones follow the SDV Skybox presets.
uniform sampler2D paintedCloudMap;
uniform float frameTimeCounter;
#include "/lib/daylight.glsl"
vec3 paintedClouds(vec3 sky) {
    if (isEyeInWater != 0 || CLOUD_OPACITY <= 0.0) return sky;
    vec3 ray = normalize(skyDirection);
    // Horizon sits 6% up the texture; its top row is 55 degrees of elevation.
    float height = 0.06 + ray.y * 1.15;
    if (height <= 0.0 || height >= 1.0) return sky;
    // The panorama covers the full turn; slow drift.
    float turn = atan(ray.z, ray.x) * 0.159154943 + frameTimeCounter * 0.0002;
    vec4 cloud = texture2D(paintedCloudMap, vec2(turn, 1.0 - height)) * CLOUD_OPACITY;
    float wet = clamp(rainStrength, 0.0, 1.0);
    float day = daylightFactor(normalize(skySunDirection).y);
    float twilight = twilightFactor(normalize(skySunDirection).y);
    vec3 cloudTone = mix(vec3(0.15, 0.19, 0.28), vec3(0.96, 0.97, 1.0), day);
    cloudTone = mix(cloudTone, vec3(1.0, 0.73, 0.51), twilight * 0.65);
#if VISUAL_STYLE == 1
    cloudTone *= mix(vec3(1.0), vec3(0.66, 0.69, 0.73), DARK_STYLE_STRENGTH);
#elif VISUAL_STYLE == 2
    cloudTone *= mix(vec3(1.0), vec3(1.02, 1.01, 0.94), CARTOON_STRENGTH);
#endif
    vec3 painted = mix(cloud.rgb * cloudTone, fogColor * cloud.a, wet * 0.55);
    return sky * (1.0 - cloud.a) + painted;
}
