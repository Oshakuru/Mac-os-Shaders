#include "/lib/settings.glsl"
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex5;
uniform sampler2D depthtex0;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform int isEyeInWater;
varying vec2 uv;
const bool colortex1Clear = true;
const vec4 colortex1ClearColor = vec4(0.0, 0.0, 0.0, 0.0);
#include "/lib/depth.glsl"
#if MAKEUP_WATER == 1
const bool colortex4Clear = true;
const vec4 colortex4ClearColor = vec4(0.0, 0.0, 0.0, 0.0);
/* DRAWBUFFERS:04 */
#else
/* DRAWBUFFERS:0 */
#endif
vec4 wetReflectionTap(vec2 coord, float centerDepth, float spatialWeight) {
    vec4 sampleValue = texture2D(colortex5, clamp(coord, 0.0, 1.0));
    if (sampleValue.a < 0.0) return vec4(0.0);
    float tolerance = max(0.15, centerDepth * 0.025);
    float depthWeight = 1.0 - smoothstep(tolerance * 0.5, tolerance, abs(sampleValue.a * far - centerDepth));
    float weight = spatialWeight * depthWeight;
    return vec4(sampleValue.rgb * weight, weight);
}
void main() {
    vec3 color = texture2D(colortex0, uv).rgb;
#if RAIN_PUDDLES == 1 && WET_GROUND_REFLECTIONS > 0 && DEBUG_VIEW == 0
    vec4 wet = texture2D(colortex1, uv);
#if WET_GROUND_REFLECTIONS == 1
    const float minCoverage = 0.02;
#else
    const float minCoverage = 0.001;
#endif
    if (wet.b > minCoverage && isEyeInWater == 0) {
        float depth = texture2D(depthtex0, uv).r;
        vec3 position = reconstructViewPosition(uv, depth, gbufferProjectionInverse);
#if WET_GROUND_REFLECTIONS == 1
        vec3 viewNormal = normalize(gbufferModelView[1].xyz);
        float fadeEnd = min(far * 0.65, 96.0);
        float fadeStart = min(far * 0.30, 40.0);
        float distanceFade = 1.0 - smoothstep(fadeStart * fadeStart, fadeEnd * fadeEnd, dot(position, position));
#else
        vec2 normalXZ = wet.rg * 2.0 - 1.0;
        vec3 worldNormal = normalize(vec3(normalXZ.x, sqrt(max(1.0 - dot(normalXZ, normalXZ), 0.001)), normalXZ.y));
        vec3 viewNormal = normalize(mat3(gbufferModelView) * worldNormal);
        float distanceFade = 1.0 - smoothstep(far * 0.55, far * 0.95, length(position));
#endif
        float edge = 1.0 - max(dot(normalize(-position), viewNormal), 0.0);
        float edge2 = edge * edge;
        float contribution = clamp(wet.b * (0.02 + 0.98 * edge2 * edge2 * edge) * distanceFade, 0.0, 1.0);
#if WET_GROUND_REFLECTIONS == 1
        contribution *= smoothstep(0.004, 0.012, contribution);
#endif
        if (contribution > 0.004) {
            float centerDepth = linearDepth(depth, near, far);
#if WET_REFLECTION_RESOLUTION == 0
            vec2 resolution = max(floor(vec2(viewWidth, viewHeight) * 0.5), vec2(1.0));
            vec2 texel = uv * resolution - 0.5;
            vec2 base = floor(texel);
            vec2 blend = fract(texel);
            vec4 reflected = wetReflectionTap((base + vec2(0.5, 0.5)) / resolution, centerDepth, (1.0-blend.x)*(1.0-blend.y));
            reflected += wetReflectionTap((base + vec2(1.5, 0.5)) / resolution, centerDepth, blend.x*(1.0-blend.y));
            reflected += wetReflectionTap((base + vec2(0.5, 1.5)) / resolution, centerDepth, (1.0-blend.x)*blend.y);
            reflected += wetReflectionTap((base + vec2(1.5, 1.5)) / resolution, centerDepth, blend.x*blend.y);
#else
            vec4 reflected = wetReflectionTap(uv, centerDepth, 1.0);
#endif
            // Full-resolution mask prevents reflections on dry objects; depth weights
            // reject samples across geometry edges. Missing samples retain the base.
            if (reflected.a > 0.01) color = mix(color, reflected.rgb / reflected.a, contribution);
        }
    }
#endif
    gl_FragData[0] = vec4(color, 1.0);
#if MAKEUP_WATER == 1
    gl_FragData[1] = vec4(color, 1.0);
#endif
}
