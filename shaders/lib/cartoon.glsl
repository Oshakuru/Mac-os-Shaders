// Independent Prizma-inspired LDR adaptation, without reference assets/curves.
vec3 cartoonHorizon(float day, float twilight) {
    return mix(mix(vec3(0.055, 0.16, 0.22), vec3(0.87, 0.83, 0.95), day), vec3(0.96, 0.52, 0.36), twilight * 0.85);
}
vec3 cartoonSky(vec3 direction, vec3 sunDirection, float day, float twilight, float rain) {
    vec3 ray = normalize(direction);
    vec3 zenith = mix(vec3(0.025, 0.085, 0.075), vec3(0.43, 0.52, 0.84), day);
    zenith = mix(zenith, vec3(0.43, 0.34, 0.46), twilight * 0.75);
    vec3 c = mix(cartoonHorizon(day, twilight), zenith, smoothstep(0.0, 0.8, max(ray.y, 0.0)));
    float facing = max(dot(ray, normalize(sunDirection)), 0.0);
    float glow = facing * facing; glow *= glow; glow *= glow; glow *= glow;
    float wet = clamp(rain, 0.0, 1.0);
    c = mix(c, mix(vec3(1.0, 0.91, 0.78), vec3(1.0, 0.64, 0.38), twilight), glow * day * 0.45 * (1.0 - wet));
    float gray = dot(c, vec3(0.2126, 0.7152, 0.0722));
    return mix(c, vec3(gray) * vec3(0.90, 0.96, 1.0) * 0.8, wet * 0.7);
}
vec3 cartoonGrade(vec3 source) {
    vec3 c = clamp(source, 0.0, 1.0);
    float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
    // Gentle saturation increase, protecting already saturated colors.
    float chroma = max(c.r, max(c.g, c.b)) - min(c.r, min(c.g, c.b));
    c = mix(vec3(luma), c, 1.08 - 0.08 * chroma);
    float shade = 1.0 - smoothstep(0.10, 0.60, luma);
    c *= mix(vec3(1.0), vec3(1.025, 0.96, 1.07), shade * 0.45);
    // Lift midtones while preserving black and white endpoints.
    c = clamp(c, 0.0, 1.0);
    c += 0.14 * c * (1.0 - c);
    c = mix(c, c * c * (3.0 - 2.0 * c), 0.10);
    return mix(source, clamp(c, 0.0, 1.0), CARTOON_STRENGTH);
}
