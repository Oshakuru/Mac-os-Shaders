#if RAIN_PUDDLES == 1 && defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING)
attribute vec4 mc_Entity;
uniform vec3 cameraPosition;
varying vec3 wetWorldPosition;
varying float wetEligible;
void prepareWetGround(vec4 viewPos) {
    wetWorldPosition = (gbufferModelViewInverse * viewPos).xyz + cameraPosition;
    wetEligible = abs(mc_Entity.x - 10002.0) > 0.5 ? 1.0 : 0.0;
}
#endif
