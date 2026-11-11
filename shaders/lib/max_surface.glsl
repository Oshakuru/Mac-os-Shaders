// Independent additive lighting, evaluated before surface tone mapping.
vec3 maxIllumination(vec3 vanilla) {
    vec2 level = clamp((lm - vec2(0.03125)) / 0.9375, 0.0, 1.0);
    float sky = level.y * level.y;
    float block = level.x * level.x;
#if TORCH_FALLOFF >= 2
    block *= level.x;
#endif
#if TORCH_FALLOFF >= 3
    block *= level.x;
#endif
    float wet = clamp(rainStrength, 0.0, 1.0);
    float ndotl = max(lightCosine, 0.0);
    float visibilityTerm = 1.0;
    if (ndotl > 0.001 && sky > 0.001) visibilityTerm = visibility(ndotl);
    float direct = ndotl * horizon * mix(1.0, visibilityTerm, SHADOW_STRENGTH);
    vec3 sun = mix(vec3(0.64, 0.75, 1.0), vec3(1.0, 0.90, 0.73), daylight);
    vec3 skyTint = mix(vec3(0.57, 0.70, 1.0), vec3(0.77, 0.88, 1.0), daylight);
#if VISUAL_STYLE == 1
    sun = mix(sun, mix(vec3(0.48, 0.60, 0.88), vec3(0.88, 0.80, 0.63), daylight), DARK_STYLE_STRENGTH);
    skyTint = mix(skyTint, vec3(0.53, 0.67, 0.73), DARK_STYLE_STRENGTH * daylight);
#elif VISUAL_STYLE == 2
    vec3 paintedSun = mix(vec3(0.58, 0.76, 1.0), vec3(1.0, 0.94, 0.77), daylight);
    paintedSun = mix(paintedSun, vec3(1.0, 0.81, 0.55), styleTwilight * 0.65);
    sun = mix(sun, paintedSun, CARTOON_STRENGTH);
    skyTint = mix(skyTint, mix(vec3(0.48, 0.69, 1.0), vec3(0.73, 0.91, 0.98), daylight), CARTOON_STRENGTH);
#endif
    // Sheltered faces keep sky fill; torchlight remains a separate contribution.
    float hemisphere = 0.65 + 0.35 * max(normalize(worldNormal).y, 0.0);
    float fill = mix(NIGHT_AMBIENT * 0.055, AMBIENT_LIGHT * 0.62, daylight);
    vec3 ambient = skyTint * sky * hemisphere * fill * (1.0 + 0.35 * wet);
    vec3 directional = sun * sky * direct * mix(0.07 * MOON_CONTRAST, 2.5, daylight) * (1.0 - 0.85 * wet);
    vec3 local = vec3(1.0, 0.70, 0.38) * block * 1.8;
    // Retain lightmap-only effects such as Night Vision when unusually bright
    // light exists without either sky or block light; this is a heuristic.
    float unusualLight = (1.0 - smoothstep(0.05, 0.35, max(level.x, level.y)))
                       * smoothstep(0.25, 0.75, max(vanilla.r, max(vanilla.g, vanilla.b)));
    return ambient + directional + local + vec3(0.003) + pow(max(vanilla, vec3(0.0)), vec3(2.2)) * unusualLight;
}
vec3 maxSurface(vec3 albedo, vec3 illumination) {
    vec3 radiance = pow(max(albedo, vec3(0.0)), vec3(2.2)) * illumination;
    // Luminance-based shoulder preserves light color while compressing highlights.
    float luma = dot(radiance, vec3(0.2126, 0.7152, 0.0722));
    radiance *= (1.0 + luma / 6.25) / (1.0 + luma);
    return pow(clamp(radiance, 0.0, 1.0), vec3(1.0 / 2.2));
}
