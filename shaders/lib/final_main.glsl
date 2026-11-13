#include "/lib/settings.glsl"
uniform sampler2D colortex0;
#if DEBUG_VIEW == 2 || ((MAX_SUNBEAMS == 1 && SHADOWS == 1) && !defined(NO_MAX_LIGHTING))
uniform sampler2D shadowtex0;
#endif
varying vec2 uv;
#if VISUAL_STYLE == 1 && DEBUG_VIEW == 0
#include "/lib/dark_fantasy.glsl"
#elif VISUAL_STYLE == 2 && DEBUG_VIEW == 0
#include "/lib/cartoon.glsl"
#endif
#if (MAX_AO == 1 || (MAX_SUNBEAMS == 1 && SHADOWS == 1)) && !defined(NO_MAX_LIGHTING) && DEBUG_VIEW == 0
#include "/lib/pro_max.glsl"
#endif
#if BLOOM == 1 && DEBUG_VIEW == 0
uniform sampler2D colortex6;
const bool colortex6MipmapEnabled = true;
#if !((MAX_AO == 1 || (MAX_SUNBEAMS == 1 && SHADOWS == 1)) && !defined(NO_MAX_LIGHTING)) && FXAA == 0
uniform float viewWidth;
uniform float viewHeight;
#endif
vec3 bloomLevel(float lod) {
    // Four diagonal taps per mip level hide the blocky look of a single coarse sample.
    vec2 o = exp2(lod) * 0.5 / vec2(viewWidth, viewHeight);
    return (texture2D(colortex6, uv + o, lod) + texture2D(colortex6, uv - o, lod)
          + texture2D(colortex6, uv + vec2(o.x, -o.y), lod) + texture2D(colortex6, uv + vec2(-o.x, o.y), lod)).rgb * 0.25;
}
vec3 bloom() {
    // Small radius only: a halo hugging the light source, no screen-wide haze.
    return bloomLevel(1.5) * 0.55 + bloomLevel(3.0) * 0.45;
}
#endif
#if FXAA == 1 && DEBUG_VIEW == 0
#if !((MAX_AO == 1 || (MAX_SUNBEAMS == 1 && SHADOWS == 1)) && !defined(NO_MAX_LIGHTING))
uniform float viewWidth;
uniform float viewHeight;
#endif
#include "/lib/fxaa.glsl"
#endif
void main() {
#if DEBUG_VIEW == 2
    // Unmodified depth display: no contrast clipping to hide useful ranges.
    float depth = texture2D(shadowtex0, uv).r;
    gl_FragColor = vec4(vec3(depth), 1.0);
#else
#if FXAA == 1 && DEBUG_VIEW == 0
    vec3 color = metalFXAA(uv);
#else
    vec3 color = texture2D(colortex0, uv).rgb;
#endif
#if (MAX_AO == 1 || (MAX_SUNBEAMS == 1 && SHADOWS == 1)) && !defined(NO_MAX_LIGHTING) && DEBUG_VIEW == 0
    color = proMaxLighting(color);
#endif
#if BLOOM == 1 && DEBUG_VIEW == 0
    color += bloom() * BLOOM_STRENGTH;
#endif
#if VISUAL_STYLE == 1 && DEBUG_VIEW == 0
    color = darkFantasyGrade(color);
#elif VISUAL_STYLE == 2 && DEBUG_VIEW == 0
    color = cartoonGrade(color);
#endif
#if DEBUG_VIEW == 0
    color *= GRADE_BRIGHTNESS;
    color = (color - 0.5) * GRADE_CONTRAST + 0.5;
    float gradeLuma = dot(color, vec3(0.2126, 0.7152, 0.0722));
    float greenWeight = smoothstep(0.02, 0.16, color.g - max(color.r, color.b));
    color = mix(vec3(gradeLuma), color, GRADE_SATURATION * mix(1.0, GRADE_GREEN_SATURATION, greenWeight));
    color = clamp(color, 0.0, 1.0);
#endif
    gl_FragColor = vec4(color, 1.0);
#endif
}
