// Shared by caster and receiver: reserve more texels near the view center.
// A radial rational mapping; no third-party source is included.
vec3 focusShadow(vec3 p) {
    float radius = length(p.xy);
    p.xy /= 0.35 + 0.65 * radius;
    return p;
}
