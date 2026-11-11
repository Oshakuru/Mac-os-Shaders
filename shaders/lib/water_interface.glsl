#ifndef METAL_WATER_INTERFACE
#define METAL_WATER_INTERFACE
#if MAKEUP_WATER == 1 && defined(MAKEUP_WATER_PASS)
varying float makeupWaterMask;
varying vec3 makeupViewPosition;
#if WATER_REFLECTIONS > 0 || WATER_REFRACTION == 1
#ifdef WORLD_LIGHTING
#define makeupPlayerPosition playerPos
#define makeupWorldNormal worldNormal
#else
varying vec3 makeupPlayerPosition;
varying vec3 makeupWorldNormal;
#endif
varying vec3 makeupSunDirection;
varying vec2 makeupTimeOfDay;
#endif
#endif
#endif
