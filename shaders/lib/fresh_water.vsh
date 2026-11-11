#if FRESH_WATER == 1 && defined(FRESH_WATER_PASS)
attribute vec4 mc_Entity;
varying float freshWaterMask;
varying vec3 freshWorldPosition;
varying vec3 freshWorldNormal;
uniform vec3 cameraPosition;
void prepareFreshWater(vec4 viewPos) {
    freshWaterMask = abs(mc_Entity.x - 10001.0) < 0.5 ? 1.0 : 0.0;
    freshWorldPosition = (gbufferModelViewInverse * viewPos).xyz + cameraPosition;
    freshWorldNormal = mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal);
}
#endif
