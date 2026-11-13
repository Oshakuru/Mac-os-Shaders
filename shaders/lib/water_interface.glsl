#ifndef METAL_WATER_INTERFACE
#define METAL_WATER_INTERFACE
#if CUSTOM_WATER == 1 && defined(WATER_PASS)
varying float waterMask;
varying vec3 waterViewPosition;
#ifdef WORLD_LIGHTING
#define waterPlayerPosition playerPos
#define waterWorldNormal worldNormal
#else
varying vec3 waterPlayerPosition;
varying vec3 waterWorldNormal;
#endif
varying vec3 waterSunDirection;
varying vec2 waterTimeOfDay;
#endif
#endif
