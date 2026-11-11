#if FRESH_WATER == 1 && defined(FRESH_WATER_PASS)
attribute vec4 mc_Entity;
varying float freshWaterMask;
varying vec3 freshWorldPosition;
varying vec3 freshWorldNormal;
uniform vec3 cameraPosition;
varying vec3 photonViewPosition;
varying vec3 photonSunDirection;
varying vec2 photonTimeOfDay;
void prepareFreshWater(vec4 viewPos) {
    photonViewPosition = viewPos.xyz;
    photonSunDirection = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    float sunHeight = photonSunDirection.y;
    photonTimeOfDay.x = smoothstep(-0.08, 0.12, sunHeight);
    photonTimeOfDay.y = (1.0 - smoothstep(0.04, 0.32, abs(sunHeight))) * smoothstep(-0.14, 0.04, sunHeight);
    freshWaterMask = abs(mc_Entity.x - 10001.0) < 0.5 ? 1.0 : 0.0;
    freshWorldPosition = (gbufferModelViewInverse * viewPos).xyz + cameraPosition;
    freshWorldNormal = mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal);
}
#endif
