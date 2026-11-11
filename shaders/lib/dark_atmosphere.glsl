// Palette authored from supplied visual references, in the existing LDR space.
vec3 fantasyHorizon(float day, float twilight) {
    vec3 c = mix(vec3(0.115, 0.105, 0.18), vec3(0.73, 0.75, 0.66), day);
    return mix(c, vec3(0.76, 0.37, 0.17), twilight * 0.92);
}
vec3 fantasySky(vec3 direction, vec3 sunDirection, float day, float twilight, float rain) {
    vec3 ray = normalize(direction);
    vec3 sunRay = normalize(sunDirection);
    vec3 zenith = mix(vec3(0.075, 0.065, 0.125), vec3(0.30, 0.355, 0.345), day);
    zenith = mix(zenith, vec3(0.40, 0.205, 0.14), twilight * 0.80);
    float height = smoothstep(0.0, 0.78, max(ray.y, 0.0));
    vec3 c = mix(fantasyHorizon(day, twilight), zenith, height);
    // Broad directional glow, with no raymarch, bloom buffer or texture fetch.
    // The moon is opposite the sun in Minecraft's standard celestial orbit.
    float sunFacing = max(dot(ray, sunRay), 0.0);
    float moonFacing = max(dot(ray, -sunRay), 0.0);
    float sunGlow = sunFacing * sunFacing;
    sunGlow *= sunGlow;
    sunGlow *= sunGlow;
    float moonGlow = moonFacing * moonFacing;
    moonGlow *= moonGlow;
    moonGlow *= moonGlow;
    moonGlow *= moonGlow;
    vec3 warmGlow = mix(vec3(0.91, 0.83, 0.68), vec3(0.98, 0.56, 0.24), twilight);
    float wet = clamp(rain, 0.0, 1.0);
    c = mix(c, warmGlow, sunGlow * day * (0.30 + 0.15 * twilight) * (1.0 - wet));
    c = mix(c, vec3(0.35, 0.28, 0.46), moonGlow * (1.0 - day) * 0.62 * (1.0 - wet));
    float gray = dot(c, vec3(0.2126, 0.7152, 0.0722));
    return mix(c, vec3(gray) * vec3(0.91, 0.96, 1.0) * 0.78, wet * 0.75);
}
