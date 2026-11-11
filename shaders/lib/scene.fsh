#include "/lib/settings.glsl"
#include "/lib/interface.glsl"
uniform sampler2D texture;
uniform vec3 fogColor;
uniform float fogStart;
uniform float fogEnd;
uniform float alphaTestRef;
#if VISUAL_STYLE > 0
uniform int isEyeInWater;
uniform ivec2 eyeBrightnessSmooth;
#ifndef WORLD_LIGHTING
uniform float rainStrength;
#endif
#endif
#ifdef ENTITY
uniform vec4 entityColor;
#endif
#ifdef LIT
#include "/lib/lighting.glsl"
#endif
#if VISUAL_STYLE > 0 && !defined(NO_SHADOW)
#if VISUAL_STYLE == 1
#include "/lib/dark_atmosphere.glsl"
#else
#include "/lib/cartoon.glsl"
#endif
#if defined(SKY_BASIC) || defined(SKY_TEXTURED)
uniform int renderStage;
#endif
#endif
/* DRAWBUFFERS:0 */
void main() {
#ifdef WORLD_LIGHTING
    // Derivatives must be evaluated on the full fragment group, before any
    // alpha discard and before evaluateLighting's early-outs.
    prepareShadowReceiver();
#endif
#ifdef UNTEXTURED
    vec4 color = tint;
#else
    vec4 color = texture2D(texture, uv) * tint;
#endif
    if (color.a < alphaTestRef) discard;
#if VISUAL_STYLE > 0 && defined(SKY_TEXTURED) && !defined(NO_SHADOW) && DEBUG_VIEW == 0
    if (renderStage == MC_RENDER_STAGE_SUN && isEyeInWater == 0) {
        // Keep the supplied sun texture's silhouette and soft outer pixels.
        // Warm the core and rim independently, without an extra texture read.
        vec3 originalSun = color.rgb;
        float edge = smoothstep(0.06, 0.32, max(abs(uv.x - 0.5), abs(uv.y - 0.5)));
        vec3 core = mix(vec3(1.0, 0.91, 0.73), vec3(1.0, 0.72, 0.36), styleTwilight);
        vec3 rim = mix(vec3(0.94, 0.73, 0.46), vec3(0.94, 0.43, 0.17), styleTwilight);
        #if VISUAL_STYLE == 2
        core = mix(vec3(1.0, 0.96, 0.86), vec3(1.0, 0.78, 0.48), styleTwilight);
        rim = mix(vec3(1.0, 0.85, 0.65), vec3(1.0, 0.56, 0.30), styleTwilight);
#endif
        vec3 sunColor = originalSun * mix(core, rim, edge * 0.65);
        #if VISUAL_STYLE == 1
        color.rgb = mix(originalSun, sunColor, DARK_STYLE_STRENGTH);
#else
        color.rgb = mix(originalSun, sunColor, CARTOON_STRENGTH);
#endif
        // Celestial geometry must not receive terrain-distance haze.
        gl_FragData[0] = color;
        return;
    }
#endif
#ifdef ENTITY
    color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);
#endif
#ifdef LIT
    color.rgb *= evaluateLighting();
#endif
    float fog = clamp((fogDistance - fogStart) / max(fogEnd - fogStart, 0.001), 0.0, 1.0);
    vec3 atmosphereColor = fogColor;
#if VISUAL_STYLE == 1 && !defined(NO_SHADOW)
    // A distance-haze approximation, not a volumetric scattering pass.
    // Preserve underwater/lava/powder-snow fog and the diagnostic modes.
#if DEBUG_VIEW == 0
    if (isEyeInWater == 0) {
        float hazeRange = max(fogEnd - 24.0, 1.0);
        float hazeDistance = clamp((fogDistance - 24.0) / hazeRange, 0.0, 1.0);
        // Viewer skylight keeps outdoor atmosphere out of deep caves.
        // Surface skylight also protects sheltered lit geometry.
        float skyExposure = smoothstep(0.02, 0.65, clamp(float(eyeBrightnessSmooth.y) / 240.0, 0.0, 1.0));
#ifdef LIT
        skyExposure *= smoothstep(0.04, 0.70, lm.y);
#endif
        float wetWeather = clamp(rainStrength, 0.0, 1.0);
        float haze = min(0.85, DARK_HAZE * (1.0 + 0.75 * wetWeather))
                   * DARK_STYLE_STRENGTH * skyExposure * hazeDistance * hazeDistance;
        fog = max(fog, haze);
        vec3 mist = fantasyHorizon(styleDay, styleTwilight);
        // A gentle dusk bridge avoids carrying the daytime teal target
        // unchanged into low-sun scenes. It is not an atmosphere simulation.
        // Dusk color is shared with the sky horizon.
        // Rain softens the dusk warmth without adding a screen-space pass.
        float mistLuma = dot(mist, vec3(0.2126, 0.7152, 0.0722));
        mist = mix(mist, vec3(mistLuma) * vec3(0.96, 1.0, 1.04), wetWeather * 0.55);
        atmosphereColor = mix(fogColor, mist, 0.55 * DARK_STYLE_STRENGTH * skyExposure);
    }
#endif
#endif
#if VISUAL_STYLE == 2 && !defined(NO_SHADOW) && DEBUG_VIEW == 0
    if (isEyeInWater == 0) {
        float exposure = smoothstep(0.02, 0.65, clamp(float(eyeBrightnessSmooth.y) / 240.0, 0.0, 1.0));
#ifdef LIT
        exposure *= smoothstep(0.04, 0.70, lm.y);
#endif
        float distanceHaze = clamp((fogDistance - 32.0) / max(fogEnd - 32.0, 1.0), 0.0, 1.0);
        fog = max(fog, distanceHaze * distanceHaze * 0.18 * CARTOON_STRENGTH * exposure);
        atmosphereColor = mix(fogColor, cartoonHorizon(styleDay, styleTwilight), 0.60 * CARTOON_STRENGTH * exposure);
    }
#endif
    color.rgb = mix(color.rgb, atmosphereColor, fog);
#ifdef WORLD_LIGHTING
#if DEBUG_VIEW == 1
    color.rgb = vec3(visibility(clamp(lightCosine, 0.0, 1.0)));
#elif DEBUG_VIEW == 3
    color.rgb = normalize(worldNormal) * 0.5 + 0.5;
#endif
#endif
#if VISUAL_STYLE > 0 && defined(SKY_BASIC) && !defined(NO_SHADOW) && DEBUG_VIEW == 0
    // Iris identifies the sky disc separately from stars, sunset and void.
    // Only replace the sky disc; retain the other geometry and its alpha.
    if (renderStage == MC_RENDER_STAGE_SKY && isEyeInWater == 0) {
        #if VISUAL_STYLE == 1
        color.rgb = mix(color.rgb, fantasySky(skyDirection, skySunDirection, styleDay, styleTwilight, rainStrength), DARK_STYLE_STRENGTH);
#else
        color.rgb = mix(color.rgb, cartoonSky(skyDirection, skySunDirection, styleDay, styleTwilight, rainStrength), CARTOON_STRENGTH);
#endif
    }
#endif
    gl_FragData[0] = color;
}
