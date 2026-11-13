// Original bright-pass for bloom. Writes only the bright part of the scene to
// target 6; final.fsh blurs it by sampling its mipmaps. LDR input, so the
// threshold is on 0..1 color: torches, lava, portals, the sun and lit windows.
#include "/lib/settings.glsl"
uniform sampler2D colortex0;
varying vec2 uv;
/* DRAWBUFFERS:6 */
void main() {
#if BLOOM == 1 && DEBUG_VIEW == 0
    vec3 color = texture2D(colortex0, uv).rgb;
    // Max channel, not luma, so saturated orange flames still pass.
    float peak = max(color.r, max(color.g, color.b));
    gl_FragData[0] = vec4(color * smoothstep(BLOOM_THRESHOLD, 1.0, peak), 1.0);
#else
    gl_FragData[0] = vec4(0.0, 0.0, 0.0, 1.0);
#endif
}
