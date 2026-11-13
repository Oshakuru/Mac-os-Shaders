#version 120
#define DH_PASS
#define LIT
#define DIRECTIONAL
#define NO_SHADOW
#define UNTEXTURED
#include "/lib/settings.glsl"
#undef SHADOWS
#define SHADOWS 0
#include "/lib/scene.vsh"
