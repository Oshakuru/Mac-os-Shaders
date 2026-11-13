// Original macOS Shaders water, vertex side: water mask, gentle surface bob.
#include "/lib/water_interface.glsl"
#if CUSTOM_WATER == 1 && defined(WATER_PASS)
#ifndef DH_PASS
attribute vec4 mc_Entity;
#endif
uniform vec3 cameraPosition;
uniform float frameTimeCounter;
void prepareWater(inout vec4 viewPos) {
#ifdef DH_PASS
    waterMask = dhMaterialId == DH_BLOCK_WATER ? 1.0 : 0.0;
#else
    waterMask = abs(mc_Entity.x - 10001.0) < 0.5 ? 1.0 : 0.0;
#endif
    vec3 player = (gbufferModelViewInverse * viewPos).xyz;
    vec3 normal = mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal);
    if (waterMask > 0.5 && normal.y > 0.9) {
        // Two slow world-space swells; continuous across blocks, a few cm high.
        vec3 world = player + cameraPosition;
        float t = frameTimeCounter;
        float swell = sin(world.x * 0.55 + world.z * 0.20 + t * 1.2)
                    + sin(world.z * 0.75 - world.x * 0.30 - t * 0.9);
        float height = swell * 0.018 * WATER_WAVE_STRENGTH;
        // World-to-view rotation is the transpose of the inverse model-view.
        viewPos.xyz += vec3(0.0, height, 0.0) * mat3(gbufferModelViewInverse);
        player.y += height;
    }
    waterViewPosition = viewPos.xyz;
    waterSunDirection = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    waterTimeOfDay = vec2(daylightFactor(waterSunDirection.y), twilightFactor(waterSunDirection.y));
#ifndef WORLD_LIGHTING
    waterPlayerPosition = player;
    waterWorldNormal = normal;
#endif
}
#endif
