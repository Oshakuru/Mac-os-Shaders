#ifndef METAL_PHOTON_INTERFACE
#define METAL_PHOTON_INTERFACE
#if PHOTON_WATER == 1 && defined(PHOTON_WATER_PASS)
varying float photonWaterMask;
varying vec3 photonViewPosition;
#if WATER_REFLECTIONS == 1
#ifdef WORLD_LIGHTING
#define photonPlayerPosition playerPos
#define photonWorldNormal worldNormal
#else
varying vec3 photonPlayerPosition;
varying vec3 photonWorldNormal;
#endif
varying vec3 photonSunDirection;
varying vec2 photonTimeOfDay;
#endif
#endif
#endif
