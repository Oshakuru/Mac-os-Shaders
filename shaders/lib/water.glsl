// Original macOS Shaders water. Approach inspired by Mellow by TheCMK (MIT):
// ordinary blended water instead of a refraction copy, depth-based opacity,
// Fresnel-weighted reflections, and cheap reflection modes. Code written here.
#if CUSTOM_WATER == 1 && defined(WATER_PASS)
uniform float frameTimeCounter;
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
uniform vec3 cameraPosition;
#if RAIN_RIPPLES == 1
uniform int biome_precipitation;
#include "/lib/rain_ripples.glsl"
#endif
#include "/lib/water_interface.glsl"
#include "/lib/depth.glsl"
const vec4 CUSTOM_WATER_COLOR = vec4(0.17, 0.28, 0.32, 1.0);

// Four directional waves with a light domain warp; returns the surface slope.
vec2 waterSlope(vec2 p, float t) {
    p += 0.6 * sin(p.yx * 0.37 + t * 0.3);
    vec2 s = vec2(0.0);
    vec2 d;
    d = vec2(0.80, 0.60);  s += d * 0.052 * cos(dot(p, d) * 1.3 + t * 1.6);
    d = vec2(-0.50, 0.87); s += d * 0.046 * cos(dot(p, d) * 2.1 + t * 2.1);
    d = vec2(0.96, -0.28); s += d * 0.037 * cos(dot(p, d) * 3.7 + t * 2.9);
    d = vec2(-0.20, -0.98); s += d * 0.031 * cos(dot(p, d) * 6.3 + t * 3.8);
    return s * WATER_WAVE_STRENGTH;
}

vec3 projectToScreen(vec3 viewPoint) {
    vec4 clip = gbufferProjection * vec4(viewPoint, 1.0);
    return clip.xyz / clip.w * 0.5 + 0.5;
}

float screenEdgeFade(vec2 p) {
    float border = min(min(p.x, 1.0 - p.x), min(p.y, 1.0 - p.y));
    return smoothstep(0.0, 0.08, border);
}

#if WATER_REFLECTIONS == 2
// One-sample reflection: look a fixed distance along the reflected ray and
// reuse whatever opaque scene is there. Cheap and stable for distant shores.
vec4 waterSceneReflection(vec3 origin, vec3 direction, float fresnel) {
    float reach = 24.0 + far * 0.25;
    vec3 target = origin + direction * reach;
    if (target.z >= -near) return vec4(0.0);
    vec3 screen = projectToScreen(target);
    if (any(lessThan(screen.xy, vec2(0.0))) || any(greaterThan(screen.xy, vec2(1.0)))) return vec4(0.0);
    float depth = texture2D(depthtex1, screen.xy).r;
    if (depth >= 0.999999) return vec4(0.0);
    // Reject foreground objects that sit closer than the water itself.
    if (linearDepth(depth, near, far) < -origin.z + 1.0) return vec4(0.0);
    return vec4(texture2D(colortex4, screen.xy).rgb, screenEdgeFade(screen.xy));
}
#elif WATER_REFLECTIONS == 3
// Screen-space march: steps are spread evenly across the screen, not world
// space, and binary refinement only runs on glancing angles that show it.
vec4 waterSceneReflection(vec3 origin, vec3 direction, float fresnel) {
    float reach = far;
    if (direction.z > 0.0) reach = min(reach, (-near * 1.5 - origin.z) / direction.z);
    if (reach <= 0.1) return vec4(0.0);
    vec3 start = projectToScreen(origin);
    vec3 end = projectToScreen(origin + direction * reach);
    vec3 stepScreen = (end - start) / float(WATER_SSR_STEPS);
    vec3 p = start + stepScreen * fract(dot(gl_FragCoord.xy, vec2(0.754877666, 0.569840296)));
    for (int i = 0; i < WATER_SSR_STEPS; i++) {
        p += stepScreen;
        if (any(lessThan(p.xy, vec2(0.0))) || any(greaterThan(p.xy, vec2(1.0)))) break;
        float depth = texture2D(depthtex1, p.xy).r;
        if (p.z > depth && depth < 0.999999) {
            if (p.z - depth > abs(stepScreen.z) * 2.0 + 0.0005) break;
            if (fresnel > 0.25) {
                vec3 s = stepScreen;
                for (int j = 0; j < 3; j++) {
                    s *= 0.5;
                    vec3 back = p - s;
                    if (back.z > texture2D(depthtex1, back.xy).r) p = back;
                }
            }
            return vec4(texture2D(colortex4, p.xy).rgb, screenEdgeFade(p.xy));
        }
    }
    return vec4(0.0);
}
#endif

vec4 applyWater(vec4 litColor) {
    if (isEyeInWater != 0) return vec4(litColor.rgb, 0.65);
    vec3 baseNormal = normalize(waterWorldNormal);
    vec3 viewDirection = normalize(-waterPlayerPosition);
    vec3 normal = baseNormal;
    if (baseNormal.y > 0.5) {
        vec3 worldPosition = waterPlayerPosition + cameraPosition;
        vec2 slope = waterSlope(worldPosition.xz, frameTimeCounter);
#if RAIN_RIPPLES == 1
        if (rainStrength > 0.001 && biome_precipitation == 1 && lm.y > 0.75) {
            slope += metalRainRippleSlope(worldPosition.xz) * 0.10 * rainStrength
                * RAIN_RIPPLE_STRENGTH * smoothstep(0.75, 0.95, lm.y);
        }
#endif
        // Calm distant water so small waves do not shimmer between pixels.
        slope /= 1.0 + length(waterPlayerPosition) * 0.03;
        normal = normalize(vec3(-slope.x, 1.0, -slope.y));
    }
    // Depth fog: shallow water stays clear, deep water turns opaque.
    vec2 screen = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float surfaceDepth = linearDepth(gl_FragCoord.z, near, far);
    float floorDepth = linearDepth(texture2D(depthtex1, screen).r, near, far);
    float thickness = max(floorDepth - surfaceDepth, 0.0);
    float bodyAlpha = mix(0.45, 1.0, smoothstep(0.0, 20.0 / WATER_FOG, thickness));
    vec3 body = litColor.rgb;
    float fresnel = 0.0;
    vec3 reflected = vec3(0.0);
    vec3 highlight = vec3(0.0);
#if WATER_REFLECTIONS > 0
    float facing = clamp(dot(normal, viewDirection), 0.0, 1.0);
    float grazing = 1.0 - facing;
    float grazing2 = grazing * grazing;
    fresnel = (0.02 + 0.98 * grazing2 * grazing2 * grazing) * 0.85;
    vec3 reflectedWorld = reflect(-viewDirection, normal);
    float exposure = smoothstep(0.1, 0.85, lm.y);
#if VISUAL_STYLE > 0 && !defined(NO_SHADOW)
    reflected = artSky(reflectedWorld, waterSunDirection, waterTimeOfDay.x, waterTimeOfDay.y, rainStrength);
#else
    reflected = mix(fogColor, skyColor, smoothstep(0.0, 1.0, pow(max(reflectedWorld.y, 0.0001), 0.333)));
#endif
    reflected *= exposure;
#if WATER_REFLECTIONS >= 2
    if (fresnel > 0.03) {
        vec3 reflectedView = normalize(mat3(gbufferModelView) * reflectedWorld);
        vec4 scene = waterSceneReflection(waterViewPosition, reflectedView, fresnel);
        reflected = mix(reflected, scene.rgb, scene.a);
    }
#endif
    vec3 astro = waterTimeOfDay.x > 0.5 ? waterSunDirection : -waterSunDirection;
    float glint = smoothstep(0.996, 1.0, max(dot(reflectedWorld, normalize(astro)), 0.0));
    highlight = vec3(1.0, 0.94, 0.82) * glint * (1.0 - rainStrength) * exposure * 0.6;
#endif
    // Blend body and reflection into one colour and one alpha for normal blending.
    float alpha = bodyAlpha * (1.0 - fresnel) + fresnel;
    vec3 rgb = (body * bodyAlpha * (1.0 - fresnel) + reflected * fresnel) / max(alpha, 0.001) + highlight;
    alpha = max(alpha, clamp(dot(highlight, vec3(0.333)), 0.0, 1.0));
    return vec4(clamp(rgb, 0.0, 1.0), alpha);
}
#endif
