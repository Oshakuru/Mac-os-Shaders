#version 120
#include "/lib/settings.glsl"
#if CLOUD_STYLE == 0
#include "/lib/scene.fsh"
#elif CLOUD_STYLE == 2
#include "/lib/fading_clouds.fsh"
#else
void main() { discard; }
#endif
