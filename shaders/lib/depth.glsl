#ifndef METAL_DEPTH
#define METAL_DEPTH
float linearDepth(float depth, float nearPlane, float farPlane) {
    return nearPlane * farPlane / max(farPlane - depth * (farPlane - nearPlane), 0.0001);
}
vec3 reconstructViewPosition(vec2 coord, float depth, mat4 inverseProjection) {
#if APPLE_DEPTH_RECONSTRUCTION == 1
    // Standard perspective inverse; unusual projections use the original path.
    mat4 m = inverseProjection;
    if (m[0][1] == 0.0 && m[0][2] == 0.0 && m[0][3] == 0.0 &&
        m[1][0] == 0.0 && m[1][2] == 0.0 && m[1][3] == 0.0) {
        float z = depth * 2.0 - 1.0;
        float w = max(m[2][3] * z + m[3][3], 0.000001);
        return vec3(m[0][0] * (coord.x * 2.0 - 1.0) + m[2][0] * z + m[3][0],
                    m[1][1] * (coord.y * 2.0 - 1.0) + m[2][1] * z + m[3][1],
                    m[2][2] * z + m[3][2]) / w;
    }
#endif
    vec4 v = inverseProjection * vec4(coord * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    return v.xyz / max(v.w, 0.000001);
}
#endif
