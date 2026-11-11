// Original Metal low-cost wind: vertex-only, no texture reads or new buffers.
uniform float frameTimeCounter;
uniform vec3 cameraPosition;
attribute vec2 mc_midTexCoord;
bool metalWindMaterial(float material) {
    return material > 10001.5 && material < 10005.5;
}
vec3 metalFoliageOffset(vec3 playerPosition, float material) {
    float distanceSquared = dot(playerPosition.xz, playerPosition.xz);
    if (distanceSquared >= 2304.0 || FOLIAGE_WIND_STRENGTH <= 0.0) return vec3(0.0);
    float fade = 1.0 - smoothstep(576.0, 2304.0, distanceSquared);
    float weight;
    float amplitude;
    if (material < 10002.5) {
        weight = 1.0;
        amplitude = 0.035; // Shared leaf vertices move coherently, with very small displacement.
    } else {
        float top = gl_MultiTexCoord0.t < mc_midTexCoord.t ? 1.0 : 0.0;
        weight = top;
        if (material > 10003.5 && material < 10004.5) weight = 0.5 + top * 0.5;
        else if (material < 10003.5) weight = top * 0.5;
        // Short grass/crops use full top weight; tall lower halves use half.
        if (material > 10004.5) weight = top;
        amplitude = 0.12;
    }
    if (weight <= 0.0) return vec3(0.0);
    vec2 worldXZ = playerPosition.xz + cameraPosition.xz;
    float phase = dot(worldXZ, vec2(0.13, 0.09)) + frameTimeCounter * 1.35;
    vec2 wave = vec2(sin(phase), sin(phase * 0.73 + 1.7));
    return vec3(wave.x, 0.0, wave.y * 0.65) * (amplitude * weight * fade * FOLIAGE_WIND_STRENGTH);
}
