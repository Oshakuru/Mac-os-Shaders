// MakeUp Ultra Fast 9.6 water adaptation — Javier Garduño, LGPL-3.0.
// Modified for Metal GLSL 120: world-space waves, LDR color, opaque snapshot,
// bounded scene reflection, and Metal rain rings. See licenses/MakeUp-UltraFast-LGPL-3.0.txt.
#if MAKEUP_WATER == 1 && defined(MAKEUP_WATER_PASS)
uniform float frameTimeCounter;
uniform sampler2D makeupWaveTexture;
uniform sampler2D colortex4;
uniform sampler2D depthtex1;
uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 skyColor;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelView;
#if VISUAL_STYLE == 0
uniform int isEyeInWater;
#ifndef WORLD_LIGHTING
uniform float rainStrength;
#endif
#endif
#if WATER_REFLECTIONS > 0 || WATER_REFRACTION == 1
uniform vec3 cameraPosition;
#if RAIN_RIPPLES == 1
uniform int biome_precipitation;
#include "/lib/rain_ripples.glsl"
#endif
#endif
#include "/lib/water_interface.glsl"
#include "/lib/depth.glsl"
// MakeUp's .05/.10/.15 default converted from linear color for Metal's LDR lighting.
const vec4 MAKEUP_WATER_COLOR = vec4(0.256, 0.351, 0.422, 1.0);
vec3 makeupWaves(vec3 position) {
    float speed = frameTimeCounter * 0.025;
    vec2 coord = position.xz - position.y * 0.2;
    vec2 wave1 = texture2D(makeupWaveTexture, coord * 0.05 + vec2(speed)).rg - 0.5;
    vec2 wave2 = texture2D(makeupWaveTexture, coord * 0.03125 - vec2(speed)).rg - 0.5;
    vec2 wave3 = (texture2D(makeupWaveTexture, coord * 0.125 + vec2(speed, -speed)).rg - 0.5) * 0.66;
    float visibleSky = smoothstep(0.1, 0.85, lm.y);
    float turbulence = 0.9 * (1.0 - rainStrength * 0.6 * visibleSky);
    return normalize(vec3((wave1 + wave2 + wave3) * WATER_WAVE_STRENGTH, max(turbulence, 0.1)));
}
#if WATER_REFLECTIONS == 2
vec4 makeupSceneReflection(vec3 origin, vec3 direction) {
    float previousTravel = 0.12;
    for (int i = 0; i < 10; i++) {
        float travel = exp2(float(i) * 0.8) * 0.35;
        vec3 point = origin + direction * travel;
        if (point.z >= -near) break;
        vec4 clip = gbufferProjection * vec4(point, 1.0);
        vec2 screen = clip.xy / clip.w * 0.5 + 0.5;
        if (any(lessThan(screen, vec2(0.01))) || any(greaterThan(screen, vec2(0.99)))) break;
        float depth = texture2D(depthtex1, screen).r;
        float delta = -point.z - linearDepth(depth, near, far);
        if (depth < 0.999999 && delta >= 0.0 && delta < 0.25 + travel * 0.08) {
            float low = previousTravel;
            float high = travel;
            for (int j = 0; j < 3; j++) {
                float mid = (low + high) * 0.5;
                vec3 q = origin + direction * mid;
                vec4 qclip = gbufferProjection * vec4(q, 1.0);
                vec2 quv = qclip.xy / qclip.w * 0.5 + 0.5;
                float sampled = texture2D(depthtex1, clamp(quv, 0.0, 1.0)).r;
                if (-q.z > linearDepth(sampled, near, far)) high = mid;
                else low = mid;
            }
            vec4 hit = gbufferProjection * vec4(origin + direction * high, 1.0);
            screen = clamp(hit.xy / hit.w * 0.5 + 0.5, 0.0, 1.0);
            float border = min(min(screen.x, 1.0 - screen.x), min(screen.y, 1.0 - screen.y));
            return vec4(texture2D(colortex4, screen).rgb, smoothstep(0.01, 0.09, border));
        }
        previousTravel = travel;
    }
    return vec4(0.0);
}
#endif
vec4 applyMakeupWater(vec4 litColor) {
    if (isEyeInWater != 0) return litColor;
    vec2 screen = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float surfaceDepth = linearDepth(gl_FragCoord.z, near, far);
    vec2 refractionSlope = vec2(0.0);
    vec3 normal;
#if WATER_REFLECTIONS > 0 || WATER_REFRACTION == 1
    vec3 worldPosition = makeupPlayerPosition + cameraPosition;
    vec3 baseNormal = normalize(makeupWorldNormal);
    vec3 bump = makeupWaves(worldPosition);
    vec3 viewDirection = normalize(-makeupPlayerPosition);
    float facing = abs(dot(baseNormal, viewDirection));
    refractionSlope = bump.xy * facing;
#if RAIN_RIPPLES == 1
    if (rainStrength > 0.001 && biome_precipitation == 1 && lm.y > 0.75 && abs(baseNormal.y) > 0.5) {
        refractionSlope += metalRainRippleSlope(worldPosition.xz) * 0.10 * rainStrength
            * RAIN_RIPPLE_STRENGTH * smoothstep(0.75, 0.95, lm.y);
    }
#endif
    // Stable tangent basis for both horizontal water and waterfall faces.
    vec3 reference = abs(baseNormal.y) > 0.9 ? vec3(1.0, 0.0, 0.0) : vec3(0.0, 1.0, 0.0);
    vec3 tangent = normalize(reference - baseNormal * dot(reference, baseNormal));
    vec3 bitangent = normalize(cross(baseNormal, tangent));
    normal = normalize(baseNormal * max(bump.z, 0.1) + tangent * refractionSlope.x + bitangent * refractionSlope.y);
    if (dot(normal, viewDirection) < 0.0) normal = -normal;
#endif
    vec2 refractedUV = screen;
#if WATER_REFRACTION == 1
    refractedUV = clamp(screen + refractionSlope * (0.075 / (1.0 + length(makeupViewPosition) * 0.4)), 0.001, 0.999);
    // Reject refraction across foreground/shore silhouettes.
    if (linearDepth(texture2D(depthtex1, refractedUV).r, near, far) <= surfaceDepth + 0.02) refractedUV = screen;
#endif
    float thickness = max(linearDepth(texture2D(depthtex1, refractedUV).r, near, far) - surfaceDepth, 0.0);
    float absorption = 1.0 - 1.0 / (thickness * thickness * WATER_ABSORPTION + 1.125);
    vec3 body = mix(texture2D(colortex4, refractedUV).rgb, litColor.rgb, absorption);
#if WATER_REFLECTIONS > 0
    vec3 reflectedWorld = reflect(-viewDirection, normal);
    float exposure = smoothstep(0.1, 0.85, lm.y);
    vec3 reflected;
#if VISUAL_STYLE > 0 && !defined(NO_SHADOW)
    reflected = artSky(reflectedWorld, makeupSunDirection, makeupTimeOfDay.x, makeupTimeOfDay.y, rainStrength);
#else
    reflected = mix(fogColor, skyColor, smoothstep(0.0, 1.0, pow(max(reflectedWorld.y, 0.0001), 0.333)));
#endif
    reflected *= exposure;
#if WATER_REFLECTIONS == 2
    vec3 reflectedView = reflect(normalize(makeupViewPosition), normalize(mat3(gbufferModelView) * normal));
    vec3 viewNormal = normalize(mat3(gbufferModelView) * normal);
    vec4 scene = makeupSceneReflection(makeupViewPosition + viewNormal * 0.08, reflectedView);
    reflected = mix(reflected, scene.rgb, scene.a);
#endif
    float edge = 1.0 - clamp(dot(normal, viewDirection), 0.0, 1.0);
    body = mix(body, reflected, edge * edge * 0.7);
    vec3 astro = makeupTimeOfDay.x > 0.5 ? makeupSunDirection : -makeupSunDirection;
    float highlight = smoothstep(0.995, 1.0, max(dot(reflectedWorld, normalize(astro)), 0.0));
    body += vec3(1.0, 0.94, 0.82) * highlight * (1.0 - rainStrength) * exposure * 0.45;
#endif
    // Refraction has already composited the opaque scene; do not blend it twice.
    return vec4(clamp(body, 0.0, 1.0), 1.0);
}
#endif
