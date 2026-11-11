#include "/lib/settings.glsl"
#include "/lib/interface.glsl"
#include "/lib/daylight.glsl"
#ifdef WORLD_LIGHTING

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

#endif
#if defined(WORLD_LIGHTING) || VISUAL_STYLE > 0 || (CUBIC_CELESTIALS == 1 && defined(SKY_BASIC) && !defined(NO_SHADOW)) || (PHOTON_WATER == 1 && WATER_REFLECTIONS == 1 && defined(PHOTON_WATER_PASS))
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
#endif
#include "/lib/photon_water.vsh"
#include "/lib/wet_ground.vsh"
void main() {
    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
#if RAIN_PUDDLES == 1 && defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING)
    prepareWetGround();
#endif
#if PHOTON_WATER == 1 && defined(PHOTON_WATER_PASS)
    preparePhotonWater(viewPos);
#endif
    gl_Position = gl_ProjectionMatrix * viewPos;
    uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    // Biome tint, vanilla AO and transparency must survive the lighting stage.
    tint = gl_Color;
    fogDistance = length(viewPos.xyz);
#if (VISUAL_STYLE > 0 || CUBIC_CELESTIALS == 1) && defined(SKY_BASIC) && !defined(NO_SHADOW)
    skyDirection = mat3(gbufferModelViewInverse) * viewPos.xyz;
    skySunDirection = mat3(gbufferModelViewInverse) * normalize(sunPosition);
#endif
#ifdef LIT
    lm = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
#endif
#ifdef WORLD_LIGHTING
    vec3 viewNormal = normalize(gl_NormalMatrix * gl_Normal);
    worldNormal = normalize(mat3(gbufferModelViewInverse) * viewNormal);
    playerPos = (gbufferModelViewInverse * viewPos).xyz;
    lightCosine = dot(viewNormal, normalize(shadowLightPosition));
    ambientHemisphere = 0.82 + 0.18 * max(worldNormal.y, 0.0);
    float sunHeight = (mat3(gbufferModelViewInverse) * normalize(sunPosition)).y;
    daylight = daylightFactor(sunHeight);
    horizon = smoothstep(0.01, 0.15, abs(sunHeight));
    // Orthographic shadow projection is linear. Move its matrix products to
    // vertices; keep the nonlinear focusing and depth comparison per pixel.
    float ndotl = max(lightCosine, 0.0);
    float texelWorldSize = 2.0 * shadowDistance / float(shadowMapResolution);
    vec4 centerClip = shadowProjection * shadowModelView * vec4(playerPos, 1.0);
    float focusScale = clamp(0.35 + 0.65 * length(centerClip.xy / centerClip.w), 0.35, 1.0);
    // Focused near-camera texels need less normal displacement than uniform
    // projection texels. This reduces excessive separation at contact points.
    float normalOffset = texelWorldSize * focusScale * (0.45 + 0.8 * (1.0 - ndotl)) * SHADOW_BIAS;
    vec4 normalClip = shadowProjection * shadowModelView * vec4(worldNormal * normalOffset, 0.0);
    vec4 clip = centerClip + normalClip;
    shadowClip = clip.xyz / clip.w;
#endif
#if VISUAL_STYLE > 0
#ifdef WORLD_LIGHTING
    styleDay = daylight;
    float styleSunHeight = sunHeight;
#else
    float styleSunHeight = (mat3(gbufferModelViewInverse) * normalize(sunPosition)).y;
    styleDay = daylightFactor(styleSunHeight);
#endif
    styleTwilight = twilightFactor(styleSunHeight);
#endif

}
