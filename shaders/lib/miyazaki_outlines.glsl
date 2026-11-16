#ifndef FINAL_PRO_LIGHTING
uniform sampler2D depthtex0;
uniform sampler2D depthtex2;
uniform mat4 gbufferProjectionInverse;
uniform int isEyeInWater;
#endif
#include "/lib/depth.glsl"
float outlineDepth(vec2 coord) {
    coord = clamp(coord, 0.5 / vec2(viewWidth, viewHeight), 1.0 - 0.5 / vec2(viewWidth, viewHeight));
    return -reconstructViewPosition(coord, texture2D(depthtex2, coord).r, gbufferProjectionInverse).z;
}
vec3 miyazakiOutlines(vec3 color) {
    if (isEyeInWater != 0 || CARTOON_STRENGTH <= 0.0) return color;
    float depth = texture2D(depthtex0, uv).r;
    float solidDepth = texture2D(depthtex2, uv).r;
    if (depth >= 0.999999 || abs(depth - solidDepth) > 0.000001) return color;
    vec3 position = reconstructViewPosition(uv, depth, gbufferProjectionInverse);
    float distanceToSurface = length(position);
    if (distanceToSurface <= 1.0 || distanceToSurface >= 48.0) return color;
    float center = -position.z;
    vec2 pixel = 1.0 / vec2(viewWidth, viewHeight);
    vec2 pairX = vec2(outlineDepth(uv - vec2(pixel.x, 0.0)), outlineDepth(uv + vec2(pixel.x, 0.0)));
    vec2 pairY = vec2(outlineDepth(uv - vec2(0.0, pixel.y)), outlineDepth(uv + vec2(0.0, pixel.y)));
    // A second difference suppresses smooth slopes; positive changes draw inside silhouettes.
    vec2 curvature = vec2(pairX.x + pairX.y, pairY.x + pairY.y) / max(center, 0.001) - 2.0;
    float edge = smoothstep(0.04, 0.16, max(curvature.x, curvature.y));
    float fade = 1.0 - smoothstep(16.0, 48.0, distanceToSurface);
    // Colored shading keeps edges soft instead of replacing them with black ink.
    return mix(color, color * vec3(0.65, 0.72, 0.76), edge * fade * 0.45 * CARTOON_STRENGTH);
}
