#version 120
#include "/lib/settings.glsl"
#if CLOUD_STYLE == 0
#include "/lib/scene.vsh"
#else
#include "/lib/clouds.vsh"
#endif
