#if FRESH_WATER == 1 && defined(FRESH_WATER_PASS)
uniform sampler2D freshStillTexture;
uniform sampler2D freshFlowTexture;
uniform float frameTimeCounter;
varying float freshWaterMask;
varying vec3 freshWorldPosition;
varying vec3 freshWorldNormal;
vec4 sampleFreshWater() {
    vec3 n = abs(freshWorldNormal);
    if (n.y >= max(n.x, n.z)) {
        // Source still sheet: 32 frames, two game ticks per frame.
        float frame = mod(floor(frameTimeCounter * 10.0), 32.0);
        vec2 tileUV = fract(freshWorldPosition.xz);
        // Half-texel inset keeps animation frames from bleeding together.
        tileUV = clamp(tileUV, vec2(0.5 / 16.0), vec2(1.0 - 0.5 / 16.0));
        return texture2D(freshStillTexture, vec2(tileUV.x, (tileUV.y + frame) / 32.0));
    }
    // Source flowing sheet: explicitly plays frames 0..15 at one tick per frame.
    float frame = mod(floor(frameTimeCounter * 20.0), 16.0);
    float horizontal = n.x > n.z ? freshWorldPosition.z : freshWorldPosition.x;
    vec2 tileUV = fract(vec2(horizontal, -freshWorldPosition.y) * 0.5);
    tileUV = clamp(tileUV, vec2(0.5 / 32.0), vec2(1.0 - 0.5 / 32.0));
    return texture2D(freshFlowTexture, vec2(tileUV.x, (tileUV.y + frame) / 16.0));
}
#endif
#if FRESH_RAIN == 1 && defined(FRESH_WEATHER_PASS)
uniform sampler2D freshRainTexture;
uniform int biome_precipitation;
#endif
