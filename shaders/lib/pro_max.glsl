// Independently authored depth AO and shadow-map sampled daylight shafts.
// Uses Iris depth buffers in the existing final pass; no bloom/history buffers.
uniform sampler2D depthtex0;
uniform sampler2D depthtex2;
uniform mat4 gbufferProjectionInverse;
uniform float viewWidth;
uniform float viewHeight;
uniform int isEyeInWater;
#if (MAX_SUNBEAMS == 1 && SHADOWS == 1)
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 sunPosition;
uniform vec3 shadowLightPosition;
uniform float rainStrength;
uniform ivec2 eyeBrightnessSmooth;
uniform mat4 gbufferProjection;
#include "/lib/projection.glsl"
#endif
#if (MAX_SUNBEAMS == 1 && SHADOWS == 1) && APPLE_SUN_SETUP == 1
varying vec3 appleSunWorld;
varying vec3 appleLightDirection;
varying vec4 appleStartClip;
varying float appleShaftStrength;
#endif
#include "/lib/depth.glsl"
#if MAX_AO == 1
float maxAOTap(vec2 coord, vec3 center, vec3 normal) {
    if (any(lessThan(coord, vec2(0.0))) || any(greaterThan(coord, vec2(1.0)))) return 0.0;
    float depth = texture2D(depthtex2, coord).r;
    if (depth >= 0.999999) return 0.0;
    vec3 delta = reconstructViewPosition(coord, depth, gbufferProjectionInverse) - center;
    float d2 = dot(delta, delta);
    float planeHeight = dot(normal, delta);
    // Restrict to a local neighborhood and reject separated silhouettes.
    return smoothstep(0.025, 0.22, planeHeight) * (1.0 - smoothstep(0.20, 1.44, d2));
}
#endif
vec3 proMaxLighting(vec3 color) {
    float depth = texture2D(depthtex0, uv).r;
    float solidDepth = texture2D(depthtex2, uv).r;
    vec3 position = reconstructViewPosition(uv, depth, gbufferProjectionInverse);
#ifdef DISTANT_HORIZONS
    float lodDepth = texture2D(dhDepthTex0, uv).r;
    bool distantSurface = depth >= 0.999999 && lodDepth < 1.0;
    if (distantSurface) position = reconstructViewPosition(uv, lodDepth, dhProjectionInverse);
#endif
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
        float weight = 0.25;
#if MAX_AO_QUALITY == 2
        vec2 diagonal = stepUV * 0.70710678;
        ao += maxAOTap(uv + diagonal, position, n)
            + maxAOTap(uv - diagonal, position, n)
            + maxAOTap(uv + vec2(diagonal.x, -diagonal.y), position, n)
            + maxAOTap(uv + vec2(-diagonal.x, diagonal.y), position, n);
        weight = 0.125;
#endif
        float fade = 1.0 - smoothstep(40.0, 64.0, distanceToSurface);
        color *= 1.0 - ao * weight * MAX_AO_STRENGTH * fade;
    }
#endif
#if (MAX_SUNBEAMS == 1 && SHADOWS == 1)
#if APPLE_SUN_SETUP == 1
    vec3 sunWorld = appleSunWorld;
    float baseStrength = appleShaftStrength;
#else
    vec3 sunWorld = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    float daylightAmount = smoothstep(0.02, 0.18, sunWorld.y);
    float skyAccess = smoothstep(0.02, 0.6, float(eyeBrightnessSmooth.y) / 240.0);
    float weather = 1.0 - clamp(rainStrength, 0.0, 1.0) * 0.85;
    float baseStrength = daylightAmount * skyAccess * weather * MAX_SUNBEAM_STRENGTH;
#endif
#ifdef DISTANT_HORIZONS
    if (distantSurface) baseStrength = 0.0;
#endif
    float rayLength = min(distanceToSurface, shadowDistance * 0.85);
#if APPLE_SUN_SETUP == 1
    float facing = max(dot(normalize(position), appleLightDirection), 0.0);
#else
    float facing = max(dot(normalize(position), normalize(shadowLightPosition)), 0.0);
#endif
    // Wider forward lobe so shafts still read when the sun is off to the side.
    float phase = 0.25 + 0.75 * facing * facing;
    float strength = baseStrength * phase;
    if (strength > 0.001 && rayLength > 2.0) {
        vec3 endView = position * (rayLength / max(distanceToSurface, 0.001));
#if APPLE_SUN_SETUP == 1
        vec4 startClip = appleStartClip;
#else
        vec4 startClip = shadowProjection * (shadowModelView * (gbufferModelViewInverse * vec4(0.0, 0.0, 0.0, 1.0)));
#endif
        vec4 endClip = shadowProjection * (shadowModelView * (gbufferModelViewInverse * vec4(endView, 1.0)));
        float jitter = fract(dot(gl_FragCoord.xy, vec2(0.754877666, 0.569840296)));
        float lit = 0.0;
        for (int i = 0; i < SUNBEAM_STEPS; i++) {
            float t = (float(i) + 0.25 + jitter * 0.5) / float(SUNBEAM_STEPS);
            vec4 clip = mix(startClip, endClip, t);
            vec3 q = focusShadow(clip.xyz / clip.w) * 0.5 + 0.5;
            if (all(greaterThan(q, vec3(0.003))) && all(lessThan(q, vec3(0.997)))) {
                lit += step(q.z - 0.0002, texture2D(shadowtex0, q.xy).r);
            }
        }
        float density = 1.0 - exp(-rayLength * 0.05);
        float litFraction = lit / float(SUNBEAM_STEPS);
        vec3 shaftColor = mix(vec3(1.0, 0.86, 0.63), vec3(1.0, 0.65, 0.36), 1.0 - smoothstep(0.08, 0.4, sunWorld.y));
        // Shafts read through contrast: brighten sunlit air and dim shadowed air,
        // so beams between trees separate from the shade around them.
        color *= 1.0 - clamp(strength * density * (1.0 - litFraction) * 0.6, 0.0, 0.25);
        color = mix(color, shaftColor, clamp(strength * density * litFraction * 1.4, 0.0, 0.40));
    }
    // Screen-space crepuscular rays: march from this pixel towards the sun on
    // screen and count sky pixels, so light streams through gaps in canopies.
    // Complements the shadow-map shafts, which need open air to build up.
    vec4 sunClip = gbufferProjection * vec4(sunPosition, 1.0);
    if (sunClip.w > 0.0 && baseStrength > 0.001) {
        vec2 sunUV = sunClip.xy / sunClip.w * 0.5 + 0.5;
        vec2 toSun = sunUV - uv;
        float screenDistance = length(toSun * vec2(viewWidth / viewHeight, 1.0));
        float reach = 1.0 - smoothstep(0.0, 1.1, screenDistance);
#if LENS_FLARE == 1
        // Small, crisp ghosts mirrored through the screen centre, scaled by how
        // much of the sun is unblocked. No blur and no full-screen streaks.
        float sunVisible = 0.0;
        for (int i = 0; i < 5; i++) {
            vec2 o = vec2(float(i == 1) - float(i == 2), float(i == 3) - float(i == 4)) * 0.008;
            vec2 q = sunUV + o;
            if (all(greaterThanEqual(q, vec2(0.0))) && all(lessThanEqual(q, vec2(1.0))))
                sunVisible += step(0.999999, texture2D(depthtex0, q).r)
#ifdef DISTANT_HORIZONS
                    * dhSkyVisibility(q)
#endif
 * 0.2;
        }
        if (sunVisible > 0.0) {
            vec2 aspect = vec2(viewWidth / viewHeight, 1.0);
            vec2 axis = sunUV - 0.5;
            float centred = 1.0 - smoothstep(0.35, 0.9, length(axis * aspect));
            vec3 flare = vec3(0.0);
            // (position along the axis, radius, colour)
            vec2 g0 = 0.5 - axis * 0.45; flare += vec3(1.00, 0.80, 0.50) * (1.0 - smoothstep(0.020, 0.032, length((uv - g0) * aspect)));
            vec2 g1 = 0.5 - axis * 0.80; flare += vec3(0.55, 0.85, 0.65) * (1.0 - smoothstep(0.045, 0.060, length((uv - g1) * aspect))) * 0.6;
            vec2 g2 = 0.5 - axis * 1.25; flare += vec3(0.60, 0.65, 1.00) * (1.0 - smoothstep(0.070, 0.085, length((uv - g2) * aspect))) * 0.4;
            vec2 g3 = 0.5 + axis * 0.30; flare += vec3(1.00, 0.70, 0.45) * (1.0 - smoothstep(0.010, 0.016, length((uv - g3) * aspect))) * 0.8;
            color += flare * sunVisible * centred * baseStrength / MAX_SUNBEAM_STRENGTH * LENS_FLARE_STRENGTH * 0.25;
        }
#endif
        if (reach > 0.001) {
            const int SCREEN_SHAFT_SAMPLES = 16;
            vec2 stepUV = toSun / float(SCREEN_SHAFT_SAMPLES);
            vec2 p = uv + stepUV * fract(dot(gl_FragCoord.xy, vec2(0.569840296, 0.754877666)));
            float sky = 0.0;
            float weight = 1.0;
            float totalWeight = 0.0;
            for (int i = 0; i < SCREEN_SHAFT_SAMPLES; i++) {
                if (all(greaterThanEqual(p, vec2(0.0))) && all(lessThanEqual(p, vec2(1.0)))) {
                    sky += step(0.999999, texture2D(depthtex0, p).r)
#ifdef DISTANT_HORIZONS
                    * dhSkyVisibility(p)
#endif
 * weight;
                }
                totalWeight += weight;
                weight *= 0.93;
                p += stepUV;
            }
            float rays = sky / totalWeight;
            vec3 rayColor = mix(vec3(1.0, 0.88, 0.66), vec3(1.0, 0.66, 0.38), 1.0 - smoothstep(0.08, 0.4, sunWorld.y));
            color += rayColor * rays * reach * reach * baseStrength * 1.6;
        }
    }
#endif
    return color;
}
