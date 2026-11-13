#version 120
#define UNTEXTURED
#define DH_PASS
#define LIT
#define DIRECTIONAL
#define WATER_PASS
#include "/lib/settings.glsl"
#undef SHADOWS
#define SHADOWS 0
#include "/lib/scene.fsh"
