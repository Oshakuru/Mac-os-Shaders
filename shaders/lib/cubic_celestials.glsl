// Cubic Sun & Moon textures by JoeFly, supplied by the user.
// Composited additively into the existing sky disc, not a new fullscreen pass.
uniform sampler2D cubicSunTexture;
uniform sampler2D cubicMoonTexture;
uniform int moonPhase;
vec3 cubicCelestials(vec3 sky) {
    if (isEyeInWater != 0) return sky;
    vec3 ray = normalize(skyDirection);
    vec3 sun = normalize(skySunDirection);
    float facingSun = dot(ray, sun);
    // Reject almost the whole sky before forming sprite coordinates or sampling.
    if (abs(facingSun) < 0.94) return sky;
    bool sunSprite = facingSun > 0.0;
    vec3 center = sunSprite ? sun : -sun;
    vec3 reference = abs(center.x) < 0.95 ? vec3(1.0, 0.0, 0.0) : vec3(0.0, 0.0, 1.0);
    vec3 up = normalize(cross(center, reference));
    vec3 right = cross(up, center);
    float radius = sunSprite ? 0.30 * SUN_SIZE : 0.20;
    vec2 spriteUV = vec2(dot(ray, right), -dot(ray, up)) / (abs(facingSun) * radius * 2.0) + 0.5;
    if (any(lessThan(spriteUV, vec2(0.0))) || any(greaterThan(spriteUV, vec2(1.0)))) return sky;
    vec3 sprite;
    if (sunSprite) {
        sprite = texture2D(cubicSunTexture, spriteUV).rgb;
    } else {
        float phase = clamp(float(moonPhase), 0.0, 7.0);
        vec2 tile = vec2(mod(phase, 4.0), floor(phase / 4.0));
        // Half-texel inset avoids bleeding at atlas tile edges (8192 x 4092).
        vec2 inset = vec2(0.5 / 2048.0, 0.5 / 2046.0);
        vec2 localUV = clamp(spriteUV, inset, vec2(1.0) - inset);
        sprite = texture2D(cubicMoonTexture, (tile + localUV) / vec2(4.0, 2.0)).rgb;
    }
    // Source sprites use RGB on black, matching vanilla additive celestial blending.
    return sky + sprite * (1.0 - clamp(rainStrength, 0.0, 1.0));
}
