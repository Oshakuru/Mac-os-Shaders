#include "/lib/photon_interface.glsl"
#if PHOTON_WATER == 1 && defined(PHOTON_WATER_PASS)
attribute vec4 mc_Entity;
#if WATER_REFLECTIONS == 1
uniform vec3 cameraPosition;
#include "/lib/daylight.glsl"
#endif
void preparePhotonWater(vec4 viewPos) {
    photonWaterMask = abs(mc_Entity.x - 10001.0) < 0.5 ? 1.0 : 0.0;
    photonViewPosition = viewPos.xyz;
#if WATER_REFLECTIONS == 1
    photonSunDirection = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    photonTimeOfDay = vec2(daylightFactor(photonSunDirection.y), twilightFactor(photonSunDirection.y));
#ifndef WORLD_LIGHTING
    photonPlayerPosition = (gbufferModelViewInverse * viewPos).xyz;
    photonWorldNormal = mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal);
#endif
#endif
}
#endif
