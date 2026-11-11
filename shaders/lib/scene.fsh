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
#include "/lib/art_sky.glsl"
#if defined(SKY_BASIC) || defined(SKY_TEXTURED)
uniform int renderStage;
#endif
#endif
#if CUBIC_CELESTIALS == 1 && defined(SKY_BASIC) && !defined(NO_SHADOW)
#if VISUAL_STYLE == 0
uniform int isEyeInWater;
uniform float rainStrength;
uniform int renderStage;
#endif
#include "/lib/cubic_celestials.glsl"
#endif
#if CLOUD_STYLE == 1 && defined(SKY_BASIC) && !defined(NO_SHADOW)
#if VISUAL_STYLE == 0 && CUBIC_CELESTIALS == 0
uniform int isEyeInWater;
uniform float rainStrength;
uniform int renderStage;
#endif
#include "/lib/sdv_clouds.glsl"
#endif
#include "/lib/weather.glsl"
#include "/lib/makeup_water.glsl"
#include "/lib/wet_ground.glsl"
#ifdef WET_MASK_OUTPUT
/* DRAWBUFFERS:01 */
#else
/* DRAWBUFFERS:0 */
#endif
void main() {
#ifdef WET_MASK_OUTPUT
    gl_FragData[1] = vec4(0.0, 0.0, 0.0, 1.0);
#endif
#ifdef WORLD_LIGHTING
    // Derivatives must be evaluated on the full fragment group, before any
    // alpha discard and before evaluateLighting's early-outs.
    prepareShadowReceiver();
#endif
#ifdef UNTEXTURED
    vec4 color = tint;
#else
    vec4 surface;
#if MAKEUP_WATER == 1 && defined(MAKEUP_WATER_PASS)
    if (makeupWaterMask > 0.5) surface = MAKEUP_WATER_COLOR;
    else surface = texture2D(texture, uv);
#else
#if defined(WEATHER_PASS) && UNOBTRUSIVE_WEATHER == 1
    surface = metalWeatherTexture();
#else
    surface = texture2D(texture, uv);
#endif
#endif
    vec4 color = surface * tint;
#if MAKEUP_WATER == 1 && defined(MAKEUP_WATER_PASS)
    if (makeupWaterMask > 0.5) color = surface; // MakeUp custom color, no biome-color multiplication.
#endif
#endif
    if (color.a < alphaTestRef) discard;
#if RAIN_PUDDLES == 1 && defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING) && DEBUG_VIEW == 0
    vec4 wetSurface = wetGroundSurface();
#ifdef WET_MASK_OUTPUT
    gl_FragData[1] = wetSurface;
#endif
    color.rgb *= 1.0 - 0.33 * wetSurface.b;
#endif
#if VISUAL_STYLE > 0 && defined(SKY_BASIC) && !defined(NO_SHADOW) && DEBUG_VIEW == 0
    // Full-strength styles replace the sky completely. Finish before computing
    // terrain fog/haze that would otherwise be discarded by that replacement.
    if (ART_STYLE_STRENGTH >= 1.0 && renderStage == MC_RENDER_STAGE_SKY && isEyeInWater == 0) {
        color.rgb = artSky(skyDirection, skySunDirection, styleDay, styleTwilight, rainStrength);
#if CUBIC_CELESTIALS == 1
        color.rgb = cubicCelestials(color.rgb);
#endif
#if CLOUD_STYLE == 1
        color.rgb = metalSDVClouds(color.rgb);
#endif
        gl_FragData[0] = color;
        return;
    }
#endif
#if VISUAL_STYLE > 0 && defined(SKY_TEXTURED) && !defined(NO_SHADOW) && DEBUG_VIEW == 0
    if (renderStage == MC_RENDER_STAGE_SUN && isEyeInWater == 0) {
        // Keep the supplied sun texture's silhouette and soft outer pixels.
        // Warm the core and rim independently, without an extra texture read.
        vec3 originalSun = color.rgb;
        float edge = smoothstep(0.06, 0.32, max(abs(uv.x - 0.5), abs(uv.y - 0.5)));
        vec3 core = mix(vec3(1.0, 0.91, 0.73), vec3(1.0, 0.72, 0.36), styleTwilight);
        vec3 rim = mix(vec3(0.94, 0.73, 0.46), vec3(0.94, 0.43, 0.17), styleTwilight);
        #if VISUAL_STYLE == 2
        core = mix(vec3(1.0, 0.97, 0.87), vec3(1.0, 0.84, 0.60), styleTwilight);
        rim = mix(vec3(1.0, 0.91, 0.73), vec3(1.0, 0.69, 0.43), styleTwilight);
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
#if MAX_LIGHTING == 1 && defined(WORLD_LIGHTING) && DEBUG_VIEW == 0
    color.rgb = maxSurface(color.rgb, evaluateLighting());
#else
    color.rgb *= evaluateLighting();
#endif
#endif
#if MAKEUP_WATER == 1 && defined(MAKEUP_WATER_PASS) && DEBUG_VIEW == 0
    if (makeupWaterMask > 0.5) color = applyMakeupWater(color);
#endif
    float fog = clamp((fogDistance - fogStart) / max(fogEnd - fogStart, 0.001), 0.0, 1.0);
    vec3 atmosphereColor = fogColor;
#if VISUAL_STYLE > 0 && !defined(NO_SHADOW) && DEBUG_VIEW == 0
    if (isEyeInWater == 0) {
        float exposure = smoothstep(0.02, 0.65, clamp(float(eyeBrightnessSmooth.y) / 240.0, 0.0, 1.0));
#ifdef LIT
        exposure *= smoothstep(0.04, 0.70, lm.y);
#endif
#if VISUAL_STYLE == 1
        float distanceHaze = clamp((fogDistance - 24.0) / max(fogEnd - 24.0, 1.0), 0.0, 1.0);
        float wet = clamp(rainStrength, 0.0, 1.0);
        fog = max(fog, min(0.85, DARK_HAZE * (1.0 + 0.75 * wet))
            * DARK_STYLE_STRENGTH * exposure * distanceHaze * distanceHaze);
        vec3 mist = fantasyHorizon(styleDay, styleTwilight);
        float luma = dot(mist, vec3(0.2126, 0.7152, 0.0722));
        mist = mix(mist, vec3(luma) * vec3(0.96, 1.0, 1.04), wet * 0.55);
        atmosphereColor = mix(fogColor, mist, 0.55 * DARK_STYLE_STRENGTH * exposure);
#else
        float distanceHaze = clamp((fogDistance - 32.0) / max(fogEnd - 32.0, 1.0), 0.0, 1.0);
        fog = max(fog, distanceHaze * distanceHaze * 0.16 * CARTOON_STRENGTH * exposure);
        atmosphereColor = mix(fogColor, cartoonHorizon(styleDay, styleTwilight), 0.60 * CARTOON_STRENGTH * exposure);
#endif
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
        color.rgb = mix(color.rgb, artSky(skyDirection, skySunDirection, styleDay, styleTwilight, rainStrength), ART_STYLE_STRENGTH);
    }
#endif
#if CUBIC_CELESTIALS == 1 && defined(SKY_BASIC) && !defined(NO_SHADOW) && DEBUG_VIEW == 0
    if (renderStage == MC_RENDER_STAGE_SKY) color.rgb = cubicCelestials(color.rgb);
#endif
#if CLOUD_STYLE == 1 && defined(SKY_BASIC) && !defined(NO_SHADOW) && DEBUG_VIEW == 0
    if (renderStage == MC_RENDER_STAGE_SKY) color.rgb = metalSDVClouds(color.rgb);
#endif
    gl_FragData[0] = color;
}
