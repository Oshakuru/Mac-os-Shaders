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
void main() {
#if DEBUG_VIEW == 2
    // Unmodified depth display: no contrast clipping to hide useful ranges.
    float depth = texture2D(shadowtex0, uv).r;
    gl_FragColor = vec4(vec3(depth), 1.0);
#else
    vec3 color = texture2D(colortex0, uv).rgb;
#if (MAX_AO == 1 || (MAX_SUNBEAMS == 1 && SHADOWS == 1)) && !defined(NO_MAX_LIGHTING) && DEBUG_VIEW == 0
    color = proMaxLighting(color);
#endif
#if VISUAL_STYLE == 1 && DEBUG_VIEW == 0
    color = darkFantasyGrade(color);
#elif VISUAL_STYLE == 2 && DEBUG_VIEW == 0
    color = cartoonGrade(color);
#endif
    gl_FragColor = vec4(color, 1.0);
#endif
}
