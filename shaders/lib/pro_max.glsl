// Independently authored depth AO and shadow-map sampled daylight shafts.
// Uses Iris depth buffers in the existing final pass; no bloom/history buffers.
uniform sampler2D depthtex0;
uniform sampler2D depthtex2;
uniform mat4 gbufferProjectionInverse;
uniform float viewWidth;
uniform float viewHeight;
uniform int isEyeInWater;
#if MAX_SUNBEAMS == 1
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 sunPosition;
uniform vec3 shadowLightPosition;
uniform float rainStrength;
uniform ivec2 eyeBrightnessSmooth;
#include "/lib/projection.glsl"
#endif
vec3 maxViewPosition(vec2 coord, float depth) {
    vec4 v = gbufferProjectionInverse * vec4(coord * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    return v.xyz / max(v.w, 0.000001);
}
#if MAX_AO == 1
float maxAOTap(vec2 coord, vec3 center, vec3 normal) {
    if (any(lessThan(coord, vec2(0.0))) || any(greaterThan(coord, vec2(1.0)))) return 0.0;
    float depth = texture2D(depthtex2, coord).r;
    if (depth >= 0.999999) return 0.0;
    vec3 delta = maxViewPosition(coord, depth) - center;
    float d2 = dot(delta, delta);
    float planeHeight = dot(normal, delta);
    // Restrict to a local neighborhood and reject separated silhouettes.
    return smoothstep(0.025, 0.22, planeHeight) * (1.0 - smoothstep(0.20, 1.44, d2));
}
#endif
vec3 proMaxLighting(vec3 color) {
    float depth = texture2D(depthtex0, uv).r;
    float solidDepth = texture2D(depthtex2, uv).r;
    vec3 position = maxViewPosition(uv, depth);
#if MAX_AO == 1
    // Derivatives must execute on all pixels, before medium/geometry branches.
    vec3 n = cross(dFdx(position), dFdy(position));
    n *= inversesqrt(max(dot(n, n), 0.00000001));
    if (dot(n, -position) < 0.0) n = -n;
#endif
    // Exclude hands and transparent surfaces; keep vanilla submerged fog.
    if (isEyeInWater != 0 || abs(depth - solidDepth) > 0.000001) return color;
    float distanceToSurface = length(position);
#if MAX_AO == 1
    if (depth < 0.999999 && distanceToSurface > 1.0 && distanceToSurface < 64.0) {
        float radius = clamp(viewHeight * 0.28 / max(distanceToSurface, 1.0), 2.0, 14.0);
        vec2 stepUV = vec2(radius / viewWidth, radius / viewHeight);
        float ao = maxAOTap(uv + vec2(stepUV.x, 0.0), position, n)
                 + maxAOTap(uv - vec2(stepUV.x, 0.0), position, n)
                 + maxAOTap(uv + vec2(0.0, stepUV.y), position, n)
                 + maxAOTap(uv - vec2(0.0, stepUV.y), position, n);
        float fade = 1.0 - smoothstep(40.0, 64.0, distanceToSurface);
        color *= 1.0 - ao * 0.25 * MAX_AO_STRENGTH * fade;
    }
#endif
#if MAX_SUNBEAMS == 1
    vec3 sunWorld = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    float daylightAmount = smoothstep(0.02, 0.18, sunWorld.y);
    float skyAccess = smoothstep(0.02, 0.6, float(eyeBrightnessSmooth.y) / 240.0);
    float weather = 1.0 - clamp(rainStrength, 0.0, 1.0) * 0.85;
    float rayLength = min(distanceToSurface, shadowDistance * 0.85);
    float facing = max(dot(normalize(position), normalize(shadowLightPosition)), 0.0);
    float phase = 0.12 + 0.88 * facing * facing * facing * facing;
    float strength = daylightAmount * skyAccess * weather * phase * MAX_SUNBEAM_STRENGTH;
    if (strength > 0.001 && rayLength > 2.0) {
        vec3 endView = position * (rayLength / max(distanceToSurface, 0.001));
        vec4 startClip = shadowProjection * shadowModelView * gbufferModelViewInverse * vec4(0.0, 0.0, 0.0, 1.0);
        vec4 endClip = shadowProjection * shadowModelView * gbufferModelViewInverse * vec4(endView, 1.0);
        float jitter = fract(dot(gl_FragCoord.xy, vec2(0.754877666, 0.569840296)));
        float lit = 0.0;
        for (int i = 0; i < 6; i++) {
            float t = (float(i) + 0.25 + jitter * 0.5) / 6.0;
            vec4 clip = mix(startClip, endClip, t);
            vec3 q = focusShadow(clip.xyz / clip.w) * 0.5 + 0.5;
            if (all(greaterThan(q, vec3(0.003))) && all(lessThan(q, vec3(0.997)))) {
                lit += step(q.z - 0.0002, texture2D(shadowtex0, q.xy).r);
            }
        }
        float density = 1.0 - exp(-rayLength * 0.025);
        vec3 shaftColor = mix(vec3(1.0, 0.86, 0.63), vec3(1.0, 0.65, 0.36), 1.0 - smoothstep(0.08, 0.4, sunWorld.y));
        color = mix(color, shaftColor, clamp(strength * density * lit / 6.0, 0.0, 0.25));
    }
#endif
    return color;
}
