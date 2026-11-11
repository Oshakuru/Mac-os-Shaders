// Original lightweight spatial edge filter. No history buffers or jitter.
// Smooths high-contrast stair steps; may soften fine texture detail.
vec3 metalFXAA(vec2 coord) {
    vec2 pixel = 1.0 / vec2(viewWidth, viewHeight);
    vec3 center = texture2D(colortex0, coord).rgb;
    vec3 north = texture2D(colortex0, coord + vec2(0.0, pixel.y)).rgb;
    vec3 south = texture2D(colortex0, coord - vec2(0.0, pixel.y)).rgb;
    vec3 east = texture2D(colortex0, coord + vec2(pixel.x, 0.0)).rgb;
    vec3 west = texture2D(colortex0, coord - vec2(pixel.x, 0.0)).rgb;
    vec3 luma = vec3(0.2126, 0.7152, 0.0722);
    float c = dot(center, luma);
    float n = dot(north, luma), s = dot(south, luma);
    float e = dot(east, luma), w = dot(west, luma);
    float range = max(c, max(max(n, s), max(e, w))) - min(c, min(min(n, s), min(e, w)));
    if (range < max(0.03125, c * 0.125)) return center;
    vec3 across = abs(n - s) > abs(e - w) ? (north + south) * 0.5 : (east + west) * 0.5;
    float subpixel = clamp(abs((n+s+e+w)*0.25-c) / max(range, 0.001), 0.0, 0.5);
    return mix(center, across, subpixel);
}
