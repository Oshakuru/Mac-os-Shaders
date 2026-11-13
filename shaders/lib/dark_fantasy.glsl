// Independently authored, perceptual color treatment for the existing LDR image.
// No Bedrock resource assets, curves or engine-specific numeric scales are used.
vec3 darkFantasyGrade(vec3 source) {
    vec3 c = clamp(source, 0.0, 1.0);
    float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
    float shadowWeight = 1.0 - smoothstep(0.12, 0.65, luma);
    float highlightWeight = smoothstep(0.48, 0.95, luma);
    // Muted midtones, olive low values, restrained warm highlights.
    float saturation = mix(0.64, 0.86, highlightWeight);
    c = mix(vec3(luma), c, saturation);
    vec3 shadowTint = vec3(0.94, 0.97, 0.80);
    vec3 highlightTint = vec3(1.02, 0.985, 0.94);
    c *= mix(vec3(1.0), shadowTint, shadowWeight * 0.65);
    c *= mix(vec3(1.0), highlightTint, highlightWeight * 0.70);
    // Bounded contrast curve, blended lightly to keep dark details readable.
    c = clamp(c * 0.90, 0.0, 1.0);
    c = mix(c, c * c * (3.0 - 2.0 * c), 0.40);
    return mix(source, clamp(c, 0.0, 1.0), DARK_STYLE_STRENGTH);
}
