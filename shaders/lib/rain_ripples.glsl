// Original Metal expanding rain rings, anchored to world-space water.
// Two offset cell grids keep the cost bounded; rings die before cell edges.
vec2 metalRainRippleSlope(vec2 worldXZ) {
    vec2 slope = vec2(0.0);
    for (int layer = 0; layer < 2; layer++) {
        vec2 p = worldXZ * 0.65 + vec2(float(layer) * 0.5);
        vec2 cell = floor(p);
        float seed = fract(sin(dot(cell, vec2(127.1, 311.7)) + float(layer) * 73.3) * 43758.5453);
        float age = fract(frameTimeCounter * 0.75 + seed);
        vec2 delta = fract(p) - vec2(0.5);
        float distanceToCenter = length(delta);
        float radius = age * 0.43;
        float ringDistance = distanceToCenter - radius;
        float width = max(0.025, fwidth(distanceToCenter) * 1.5);
        float envelope = 1.0 - smoothstep(width, width * 2.0, abs(ringDistance));
        float lifetime = smoothstep(0.0, 0.12, age) * (1.0 - smoothstep(0.55, 1.0, age));
        slope += delta / max(distanceToCenter, 0.001) * sin(ringDistance * 100.0) * envelope * lifetime;
    }
    return slope;
}
