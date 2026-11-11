#if PHOTON_WATER == 1 && defined(PHOTON_WATER_PASS)
attribute vec4 mc_Entity;
varying float photonWaterMask;
varying vec3 photonWorldPosition;
varying vec3 photonWorldNormal;
uniform vec3 cameraPosition;
varying vec3 photonViewPosition;
varying vec3 photonSunDirection;
varying vec2 photonTimeOfDay;
void preparePhotonWater(vec4 viewPos) {
    photonViewPosition = viewPos.xyz;
    photonSunDirection = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    float sunHeight = photonSunDirection.y;
    photonTimeOfDay.x = smoothstep(-0.08, 0.12, sunHeight);
    photonTimeOfDay.y = (1.0 - smoothstep(0.04, 0.32, abs(sunHeight))) * smoothstep(-0.14, 0.04, sunHeight);
    photonWaterMask = abs(mc_Entity.x - 10001.0) < 0.5 ? 1.0 : 0.0;
    photonWorldPosition = (gbufferModelViewInverse * viewPos).xyz + cameraPosition;
    photonWorldNormal = mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal);
}
#endif
