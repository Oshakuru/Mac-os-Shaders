// Adapted from Photon rain_puddles.glsl, SixthSurge / Benjamin Stott.
// Photon license retained in licenses/Photon-License.txt.
#if RAIN_PUDDLES == 1 && defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING)
uniform sampler2D puddleNoise;
uniform float wetness;
uniform int biome_precipitation;
uniform float frameTimeCounter;
uniform vec3 cameraPosition;
varying float wetEligible;
float wetRipple = 0.0; // direct ring shading for scene.fsh
#if RAIN_RIPPLES == 1
#include "/lib/rain_ripples.glsl"
#endif
vec4 wetGroundSurface() {
    vec3 normal = normalize(worldNormal);
    if (wetness < 0.001 || biome_precipitation != 1 || wetEligible < 0.5 || normal.y < 0.99) return vec4(0.0, 0.0, 0.0, 1.0);
    vec2 levels = clamp((lm - vec2(0.03125)) / 0.9375, 0.0, 1.0);
    float outdoors = smoothstep(14.0 / 15.0, 1.0, levels.y) * (1.0 - levels.x * levels.x * levels.x);
    float damp = clamp(wetness, 0.0, 1.0) * outdoors;
    if (damp < 0.001) return vec4(0.0, 0.0, 0.0, 1.0);
    float noise = texture2D(puddleNoise, (playerPos.xz + cameraPosition.xz) * 0.025).a;
    float puddle = clamp((noise - 0.45) / 0.10, 0.0, 1.0) * damp;
    float coverage = max(puddle, damp * 0.12);
    vec2 ring = vec2(0.0);
#if RAIN_RIPPLES == 1
    // Same rain rings as the water, on puddles only to bound the cost.
    if (puddle > 0.0) {
        ring = metalRainRippleSlope(playerPos.xz + cameraPosition.xz) * rainStrength * RAIN_RIPPLE_STRENGTH * puddle;
        wetRipple = (ring.x + ring.y) * 0.3;
    }
#endif
#if WET_GROUND_REFLECTIONS == 2
    // Lightweight animated ripple normals using the source's two directions.
    vec2 coord = (playerPos.xz + cameraPosition.xz) * 0.3;
    vec2 a = vec2(0.6, 0.8);
    vec2 b = vec2(-0.3846154, -0.9230769);
    vec2 slope = a * cos(dot(coord, a) * 6.2831853 + frameTimeCounter * 0.6283185)
               + b * cos(dot(coord, b) * 6.2831853 + frameTimeCounter * 0.6283185);
    float angleFade = smoothstep(0.0, 0.1, abs(dot(normal, normalize(-playerPos))));
    normal = normalize(normal + (vec3(slope.x, 0.0, slope.y) * 0.025 * rainStrength * puddle + vec3(ring.x, 0.0, ring.y) * 0.06) * angleFade);
    return vec4(normal.xz * 0.5 + 0.5, coverage, 1.0);
#else
    return vec4(0.5, 0.5, coverage, 1.0);
#endif
}
#endif
