#version 120
#include "/lib/settings.glsl"
#include "/lib/projection.glsl"
#if FOLIAGE_WIND == 1
attribute vec4 mc_Entity;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
#include "/lib/foliage_wind.glsl"
#endif
varying vec2 uv;
varying vec4 tint;
void main() {
    vec4 clip = ftransform();
#if FOLIAGE_WIND == 1
    if (metalWindMaterial(mc_Entity.x)) {
        vec4 shadowView = gl_ModelViewMatrix * gl_Vertex;
        vec3 windPosition = (shadowModelViewInverse * shadowView).xyz;
        shadowView.xyz += mat3(shadowModelView) * metalFoliageOffset(windPosition, mc_Entity.x);
        clip = gl_ProjectionMatrix * shadowView;
    }
#endif
    clip.xyz = focusShadow(clip.xyz / clip.w) * clip.w;
    gl_Position = clip;
    uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    tint = gl_Color;
}
