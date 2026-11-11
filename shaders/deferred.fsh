#version 120
#include "/lib/settings.glsl"
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float rainStrength;
uniform int isEyeInWater;
uniform float near;
uniform float far;
varying vec2 uv;
const bool colortex1Clear = true;
const vec4 colortex1ClearColor = vec4(0.0);
const int colortex1Format = RGBA8;
#if VISUAL_STYLE == 1
#include "/lib/dark_atmosphere.glsl"
#elif VISUAL_STYLE == 2
#include "/lib/cartoon.glsl"
#endif
float wetLinearDepth(float d) {
    return near * far / max(far - d * (far - near), 0.0001);
}
vec3 wetViewPosition(vec2 coord, float d) {
    vec4 p = gbufferProjectionInverse * vec4(coord * 2.0 - 1.0, d * 2.0 - 1.0, 1.0);
    return p.xyz / max(p.w, 0.000001);
}
#if WET_GROUND_REFLECTIONS == 2
vec4 wetSceneReflection(vec3 origin, vec3 direction) {
    // Twelve bounded view-space steps; no history or recursive reflections.
    float previousDelta = -1.0;
    for (int i = 0; i < 12; i++) {
        float stepIndex = float(i) + 1.0;
        float travel = 0.30 + stepIndex * stepIndex * 0.18;
        vec3 point = origin + direction * travel;
        if (point.z > -near) break;
        vec4 clip = gbufferProjection * vec4(point, 1.0);
        vec2 sampleUV = clip.xy / clip.w * 0.5 + 0.5;
        if (any(lessThan(sampleUV, vec2(0.005))) || any(greaterThan(sampleUV, vec2(0.995)))) break;
        float depth = texture2D(depthtex0, sampleUV).r;
        float delta = -point.z - wetLinearDepth(depth);
        if (depth < 0.999999 && previousDelta < 0.0 && delta >= 0.0 && delta < 0.30 + travel * 0.06) {
            float border = min(min(sampleUV.x, 1.0 - sampleUV.x), min(sampleUV.y, 1.0 - sampleUV.y));
            float confidence = smoothstep(0.005, 0.08, border) * (1.0 - smoothstep(16.0, 28.0, travel));
            return vec4(texture2D(colortex0, sampleUV).rgb, confidence);
        }
        previousDelta = delta;
    }
    return vec4(0.0);
}
#endif
/* DRAWBUFFERS:0 */
void main() {
    vec3 color = texture2D(colortex0, uv).rgb;
#if RAIN_PUDDLES == 1 && WET_GROUND_REFLECTIONS > 0 && DEBUG_VIEW == 0
    vec4 wet = texture2D(colortex1, uv);
    if (wet.b > 0.001 && isEyeInWater == 0) {
        float depth = texture2D(depthtex0, uv).r;
        vec3 position = wetViewPosition(uv, depth);
        vec2 normalXZ = wet.rg * 2.0 - 1.0;
        vec3 worldNormal = normalize(vec3(normalXZ.x, sqrt(max(1.0 - dot(normalXZ, normalXZ), 0.001)), normalXZ.y));
        vec3 viewNormal = normalize(mat3(gbufferModelView) * worldNormal);
        vec3 v = normalize(-position);
        vec3 reflectedView = reflect(-v, viewNormal);
        vec3 r = normalize(mat3(gbufferModelViewInverse) * reflectedView);
        vec3 sun = mat3(gbufferModelViewInverse) * normalize(sunPosition);
        float day = smoothstep(-0.08, 0.12, sun.y);
        float twilight = (1.0 - smoothstep(0.04, 0.32, abs(sun.y))) * smoothstep(-0.14, 0.04, sun.y);
        vec3 reflected;
#if VISUAL_STYLE == 1
        reflected = fantasySky(r, sun, day, twilight, rainStrength);
#elif VISUAL_STYLE == 2
        reflected = cartoonSky(r, sun, day, twilight, rainStrength);
#else
        reflected = mix(fogColor, skyColor, smoothstep(0.0, 0.8, max(r.y, 0.0)));
#endif
        float highlight = pow(max(dot(r, normalize(sun)), 0.0), 128.0) * day * (1.0 - rainStrength);
        reflected += vec3(1.0, 0.92, 0.76) * highlight;
#if WET_GROUND_REFLECTIONS == 2
        vec4 scene = wetSceneReflection(position + viewNormal * 0.08, reflectedView);
        reflected = mix(reflected, scene.rgb, scene.a);
#endif
        float edge = 1.0 - max(dot(v, viewNormal), 0.0);
        float edge2 = edge * edge;
        float fresnel = 0.02 + 0.98 * edge2 * edge2 * edge;
        float distanceFade = 1.0 - smoothstep(far * 0.55, far * 0.95, length(position));
        color = mix(color, reflected, clamp(wet.b * fresnel * distanceFade, 0.0, 1.0));
    }
#endif
    gl_FragData[0] = vec4(color, 1.0);
}
