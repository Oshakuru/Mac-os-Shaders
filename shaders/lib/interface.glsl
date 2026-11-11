// Shared vertex/fragment contract; only allocate directional varyings when used.
#if defined(DIRECTIONAL) && !defined(NO_SHADOW)
#define WORLD_LIGHTING
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

#if VISUAL_STYLE > 0 && defined(SKY_BASIC) && !defined(NO_SHADOW) && EXTERNAL_ATMOSPHERE == 0
varying vec3 skyDirection;
varying vec3 skySunDirection;
#endif
