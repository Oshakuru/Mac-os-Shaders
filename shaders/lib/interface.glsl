// Shared vertex/fragment contract; only allocate directional varyings when used.
#if defined(DIRECTIONAL) && !defined(NO_SHADOW)
#define WORLD_LIGHTING
#endif
#if defined(WEATHER_PASS) && UNOBTRUSIVE_WEATHER == 1
varying float weatherIsRain;
#endif
varying vec2 uv;
varying vec4 tint;
varying float fogDistance;
#ifdef LIT
varying vec2 lm;
#endif
#ifdef WORLD_LIGHTING
varying vec3 playerPos;
varying vec3 worldNormal;
varying vec3 shadowClip;
varying float lightCosine;
varying float ambientHemisphere;
varying float daylight;
varying float horizon;
#endif

#if VISUAL_STYLE > 0
varying float styleDay;
varying float styleTwilight;
#endif

#if (VISUAL_STYLE > 0 || CUBIC_CELESTIALS == 1) && defined(SKY_BASIC) && !defined(NO_SHADOW)
varying vec3 skyDirection;
varying vec3 skySunDirection;
#endif

#if RAIN_PUDDLES == 1 && WET_GROUND_REFLECTIONS > 0 && DEBUG_VIEW == 0 && !defined(NO_SHADOW)
#define WET_MASK_OUTPUT
#endif

#if VISUAL_STYLE == 1
#define ART_STYLE_STRENGTH DARK_STYLE_STRENGTH
#elif VISUAL_STYLE == 2
#define ART_STYLE_STRENGTH CARTOON_STRENGTH
#endif
