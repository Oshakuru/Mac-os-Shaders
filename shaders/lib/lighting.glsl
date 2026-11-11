uniform sampler2D lightmap;
#ifdef WORLD_LIGHTING
uniform float rainStrength;
#include "/lib/shadow_sampling.glsl"
#endif
#if MAX_LIGHTING == 1 && defined(WORLD_LIGHTING) && DEBUG_VIEW == 0
#include "/lib/max_surface.glsl"
#endif
vec3 evaluateLighting() {
    // Retain Minecraft's time of day and existing light colors with one fetch.
    vec3 vanilla = texture2D(lightmap, clamp(lm, vec2(0.03125), vec2(0.96875))).rgb;
#ifdef WORLD_LIGHTING
#if MAX_LIGHTING == 1 && DEBUG_VIEW == 0
    return maxIllumination(vanilla);
#else
    float ndotl = clamp(lightCosine, 0.0, 1.0);
    float skyAccess = smoothstep(0.04, 0.90, lm.y);
    float sunlight = ndotl * horizon;
    float shadow = 1.0;
    if (sunlight > 0.001 && skyAccess > 0.001) shadow = visibility(ndotl);
    // Independently tune the night fill, smoothly blended by sun elevation.
    float fillLevel = mix(NIGHT_AMBIENT, AMBIENT_LIGHT, daylight);
    float ambient = fillLevel * ambientHemisphere;
    // Ambient fill is independent of direct sun/moon occlusion. The strength
    // option now affects cast shadows, rather than all face shading together.
    float directVisibility = mix(1.0, shadow, SHADOW_STRENGTH);
    float skyResponse = ambient + (1.0 - ambient) * sunlight * directVisibility;
    // Under overcast skies or moonlight, soften the directional contrast while
    // retaining the time-of-day brightness already encoded by the lightmap.
    float directionalWeight = mix(MOON_CONTRAST, 1.0, daylight) * (1.0 - rainStrength * 0.85);
    float skyFactor = mix(1.0, skyResponse, skyAccess * directionalWeight);
    // lm.x is block light and lm.y is sky light. Torch falloff is evaluated
    // after interpolation to avoid vertex-dependent gradients on large faces.
    float blockLevel = clamp((lm.x - 0.03125) / 0.9375, 0.0, 1.0);
    float torchProtection = blockLevel;
#if TORCH_FALLOFF >= 2
    torchProtection *= blockLevel;
#endif
#if TORCH_FALLOFF >= 3
    torchProtection *= blockLevel;
#endif
    // Preserve brightness near actual light sources without sampling a second
    // lightmap or allowing Night Vision's baseline to override every shadow.
    vec3 lighting = vanilla * mix(skyFactor, 1.0, torchProtection);
#if VISUAL_STYLE == 1 && DEBUG_VIEW == 0
    // Reference-driven separation of light roles. This uses the existing block
    // light coordinate, not a list of emitters or a colored-light transport pass.
    vec3 shadeTint = mix(vec3(0.86, 0.88, 1.15), vec3(0.82, 1.00, 1.04), styleDay);
    vec3 sunTint = mix(vec3(1.16, 1.04, 0.72), vec3(1.38, 0.84, 0.48), styleTwilight);
    vec3 directTint = mix(vec3(0.87, 0.81, 1.24), sunTint, styleDay);
    vec3 skyTint = mix(shadeTint, directTint, sunlight * directVisibility);
    vec3 sourceTint = mix(skyTint, vec3(1.08, 1.015, 0.88), torchProtection);
    // Normalize tint luminance: separate color intent from brightness controls.
    float tintLuminance = dot(sourceTint, vec3(0.2126, 0.7152, 0.0722));
    sourceTint /= max(tintLuminance, 0.001);
    lighting *= mix(vec3(1.0), sourceTint, DARK_LIGHT_TINT * DARK_STYLE_STRENGTH);
#endif
#if VISUAL_STYLE == 2 && DEBUG_VIEW == 0
    vec3 shadeTint = mix(vec3(0.85, 0.91, 1.14), vec3(0.94, 0.95, 1.10), styleDay);
    vec3 sunTint = mix(vec3(1.10, 1.02, 0.91), vec3(1.20, 0.92, 0.76), styleTwilight);
    vec3 directTint = mix(vec3(0.84, 0.92, 1.12), sunTint, styleDay);
    vec3 sourceTint = mix(mix(shadeTint, directTint, sunlight * directVisibility), vec3(1.08, 1.01, 0.88), torchProtection);
    sourceTint /= max(dot(sourceTint, vec3(0.2126, 0.7152, 0.0722)), 0.001);
    lighting *= mix(vec3(1.0), sourceTint, 0.65 * CARTOON_STRENGTH);
#endif
    return lighting;
#endif
#else
    return vanilla;
#endif
}
