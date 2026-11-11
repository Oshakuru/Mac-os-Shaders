// Cartoon palette polish: existing sky and final passes only.
vec3 cartoonHorizon(float day, float twilight) {
    vec3 horizon = mix(vec3(0.075, 0.095, 0.18), vec3(0.80, 0.88, 0.98), day);
    return mix(horizon, vec3(1.0, 0.64, 0.48), twilight * 0.82);
}
vec3 cartoonSky(vec3 direction, vec3 sunDirection, float day, float twilight, float rain) {
    vec3 ray = normalize(direction);
    vec3 zenith = mix(vec3(0.025, 0.035, 0.095), vec3(0.30, 0.53, 0.88), day);
    zenith = mix(zenith, vec3(0.38, 0.32, 0.57), twilight * 0.70);
    vec3 c = mix(cartoonHorizon(day, twilight), zenith, smoothstep(0.0, 0.8, max(ray.y, 0.0)));
    float facing = max(dot(ray, normalize(sunDirection)), 0.0);
    float glow = facing * facing; glow *= glow; glow *= glow; glow *= glow;
    float wet = clamp(rain, 0.0, 1.0);
    c = mix(c, mix(vec3(1.0, 0.94, 0.83), vec3(1.0, 0.72, 0.49), twilight), glow * day * 0.40 * (1.0 - wet));
    float gray = dot(c, vec3(0.2126, 0.7152, 0.0722));
    return mix(c, vec3(gray) * vec3(0.90, 0.96, 1.0) * 0.8, wet * 0.7);
}
vec3 cartoonGrade(vec3 source) {
    vec3 c = clamp(source, 0.0, 1.0);
    float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
    // Saturation tapers off as colors become vivid; black and white stay neutral.
    float chroma = max(c.r, max(c.g, c.b)) - min(c.r, min(c.g, c.b));
    c = mix(vec3(luma), c, 1.12 - 0.12 * chroma);
    float shade = 1.0 - smoothstep(0.10, 0.60, luma);
    c *= mix(vec3(1.0), vec3(0.99, 0.985, 1.055), shade * 0.40);
    c = clamp(c, 0.0, 1.0);
    c += 0.18 * c * (1.0 - c);
    c = mix(c, c * c * (3.0 - 2.0 * c), 0.12);
    return mix(source, clamp(c, 0.0, 1.0), CARTOON_STRENGTH);
}
