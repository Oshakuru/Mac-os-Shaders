#version 120
#include "/lib/settings.glsl"
#if CLOUD_STYLE == 0
#include "/lib/scene.vsh"
#elif CLOUD_STYLE == 2
#include "/lib/fading_clouds.vsh"
#else
void main() { gl_Position = vec4(0.0, 0.0, 2.0, 1.0); }
#endif
