#if RAIN_PUDDLES == 1 && defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING)
attribute vec4 mc_Entity;
varying float wetEligible;
void prepareWetGround() {
    wetEligible = abs(mc_Entity.x - 10002.0) > 0.5 ? 1.0 : 0.0;
}
#endif
