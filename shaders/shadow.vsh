#version 120
#include "/lib/settings.glsl"
#include "/lib/projection.glsl"
varying vec2 uv;
varying vec4 tint;
void main() {
    vec4 clip = ftransform();
    clip.xyz = focusShadow(clip.xyz / clip.w) * clip.w;
    gl_Position = clip;
    uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    tint = gl_Color;
}
