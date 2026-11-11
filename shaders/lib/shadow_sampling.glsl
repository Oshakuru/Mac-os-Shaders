#include "/lib/projection.glsl"
uniform sampler2D shadowtex0;
// Per-fragment working state, initialized before alpha discard or branches.
vec3 shadowReceiver;
vec2 shadowDepthGradient;
void prepareShadowReceiver() {
    shadowReceiver = focusShadow(shadowClip) * 0.5 + 0.5;
    shadowDepthGradient = vec2(0.0);
#if RECEIVER_CORRECTION == 1
    // Solve dz/du,dz/dv from screen-space derivatives. Each PCF tap then
    // compares against the local receiving plane rather than one flat depth.
    vec3 dx = dFdx(shadowReceiver);
    vec3 dy = dFdy(shadowReceiver);
    float determinant = dx.x * dy.y - dx.y * dy.x;
    if (abs(determinant) > 1e-10) {
        vec2 gradient = vec2(dy.y * dx.z - dx.y * dy.z,
                             dx.x * dy.z - dy.x * dx.z) / determinant;
        float maxGradient = float(shadowMapResolution) * 0.001;
        shadowDepthGradient = clamp(gradient, vec2(-maxGradient), vec2(maxGradient));
    }
#endif
}
float depthCompare(vec2 coord, float receiverDepth) {
    float planeCorrection = dot(shadowDepthGradient, coord - shadowReceiver.xy);
    return step(receiverDepth + planeCorrection, texture2D(shadowtex0, coord).r);
}
float filteredVisibility(vec3 q) {
#if SHADOW_FILTER == 0
    return depthCompare(q.xy, q.z);
#else
    // Bilinear PCF: blend four depth COMPARISONS, never blend raw depths.
    // Texel-center sampling and fractional weights avoid the old quarter-step
    // brightness changes when a shadow edge moves between texels.
    float size = float(shadowMapResolution);
    vec2 pixel = q.xy * size - 0.5;
    vec2 fraction = fract(pixel);
    vec2 base = (floor(pixel) + 0.5) / size;
    vec2 delta = vec2(1.0 / size, 0.0);
    float a = depthCompare(base, q.z);
    float b = depthCompare(base + delta.xy, q.z);
    float c = depthCompare(base + delta.yx, q.z);
    float d = depthCompare(base + delta.xx, q.z);
    return mix(mix(a, b, fraction.x), mix(c, d, fraction.x), fraction.y);
#endif
}
float visibility(float ndotl) {
    float distanceFromCamera = length(playerPos);
    if (ndotl <= 0.0 || distanceFromCamera >= shadowDistance * 0.95) return 1.0;
    vec3 q = shadowReceiver;
    if (any(lessThanEqual(q, vec3(0.003))) || any(greaterThanEqual(q, vec3(0.997)))) return 1.0;
    q.z -= (0.00015 + (1.0 - ndotl) * 0.0003) * SHADOW_BIAS;
    float result = filteredVisibility(q);
    float fade = smoothstep(shadowDistance * 0.75, shadowDistance * 0.95, distanceFromCamera);
    return mix(result, 1.0, fade);
}
