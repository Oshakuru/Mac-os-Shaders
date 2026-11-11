#ifndef METAL_ART_SKY
#define METAL_ART_SKY
#if VISUAL_STYLE == 1
#include "/lib/dark_atmosphere.glsl"
#elif VISUAL_STYLE == 2
#include "/lib/cartoon.glsl"
#endif
#if VISUAL_STYLE > 0
vec3 artSky(vec3 direction, vec3 sun, float day, float twilight, float rain) {
#if VISUAL_STYLE == 1
    return fantasySky(direction, sun, day, twilight, rain);
#else
    return cartoonSky(direction, sun, day, twilight, rain);
#endif
}
#endif
#endif
