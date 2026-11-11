#include "/lib/settings.glsl"
varying vec2 uv;
#if (MAX_SUNBEAMS == 1 && SHADOWS == 1) && APPLE_SUN_SETUP == 1 && !defined(NO_MAX_LIGHTING) && DEBUG_VIEW == 0
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 sunPosition;
uniform vec3 shadowLightPosition;
uniform float rainStrength;
uniform ivec2 eyeBrightnessSmooth;
varying vec3 appleSunWorld;
varying vec3 appleLightDirection;
varying vec4 appleStartClip;
varying float appleShaftStrength;
#endif
void main() {
    gl_Position = ftransform();
    uv = gl_MultiTexCoord0.xy;
#if (MAX_SUNBEAMS == 1 && SHADOWS == 1) && APPLE_SUN_SETUP == 1 && !defined(NO_MAX_LIGHTING) && DEBUG_VIEW == 0
    appleSunWorld = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    appleLightDirection = normalize(shadowLightPosition);
    appleStartClip = shadowProjection * shadowModelView * gbufferModelViewInverse * vec4(0.0, 0.0, 0.0, 1.0);
    appleShaftStrength = smoothstep(0.02, 0.18, appleSunWorld.y)
        * smoothstep(0.02, 0.6, float(eyeBrightnessSmooth.y) / 240.0)
        * (1.0 - clamp(rainStrength, 0.0, 1.0) * 0.85) * MAX_SUNBEAM_STRENGTH;
#endif
}
