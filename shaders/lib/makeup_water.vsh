#include "/lib/water_interface.glsl"
#if MAKEUP_WATER == 1 && defined(MAKEUP_WATER_PASS)
attribute vec4 mc_Entity;
#if WATER_REFLECTIONS > 0 || WATER_REFRACTION == 1
uniform vec3 cameraPosition;
#include "/lib/daylight.glsl"
#endif
void prepareMakeupWater(vec4 viewPos) {
    makeupWaterMask = abs(mc_Entity.x - 10001.0) < 0.5 ? 1.0 : 0.0;
    makeupViewPosition = viewPos.xyz;
#if WATER_REFLECTIONS > 0 || WATER_REFRACTION == 1
    makeupSunDirection = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    makeupTimeOfDay = vec2(daylightFactor(makeupSunDirection.y), twilightFactor(makeupSunDirection.y));
#ifndef WORLD_LIGHTING
    makeupPlayerPosition = (gbufferModelViewInverse * viewPos).xyz;
    makeupWorldNormal = mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal);
#endif
#endif
}
#endif
