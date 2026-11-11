#include "/lib/settings.glsl"
#include "/lib/interface.glsl"
#include "/lib/daylight.glsl"
#ifdef WORLD_LIGHTING

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

#endif
#if defined(WORLD_LIGHTING) || VISUAL_STYLE > 0 || ((CUBIC_CELESTIALS == 1 || CLOUD_STYLE == 1) && defined(SKY_BASIC) && !defined(NO_SHADOW)) || (MAKEUP_WATER == 1 && (WATER_REFLECTIONS > 0 || WATER_REFRACTION == 1) && defined(MAKEUP_WATER_PASS))
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
#endif
#include "/lib/makeup_water.vsh"
#include "/lib/wet_ground.vsh"
#if defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING) && RAIN_PUDDLES == 0
attribute vec4 mc_Entity;
#endif
#if FOLIAGE_WIND == 1 && defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING)
uniform mat4 gbufferModelView;
#include "/lib/foliage_wind.glsl"
#endif
#if defined(WEATHER_PASS) && UNOBTRUSIVE_WEATHER == 1
uniform sampler2D texture;
#endif
void main() {
#if defined(WEATHER_PASS) && UNOBTRUSIVE_WEATHER == 1
    // Stock 1.21.11 rain is blue here; snow is transparent/neutral.
    // Classify the draw's original texture once per vertex, before replacing it.
    vec3 weatherProbe = texture2DLod(texture, vec2(0.0546875, 0.025390625), 0.0).rgb;
    weatherIsRain = step(0.1, weatherProbe.b - weatherProbe.r);
#endif
    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
#if FOLIAGE_WIND == 1 && defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING)
    if (metalWindMaterial(mc_Entity.x)) {
        vec3 windPosition = (gbufferModelViewInverse * viewPos).xyz;
        viewPos.xyz += mat3(gbufferModelView) * metalFoliageOffset(windPosition, mc_Entity.x);
    }
#endif
#if RAIN_PUDDLES == 1 && defined(WET_GROUND_PASS) && defined(WORLD_LIGHTING)
    prepareWetGround();
#endif
#if MAKEUP_WATER == 1 && defined(MAKEUP_WATER_PASS)
    prepareMakeupWater(viewPos);
#endif
    gl_Position = gl_ProjectionMatrix * viewPos;
    uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    // Biome tint, vanilla AO and transparency must survive the lighting stage.
    tint = gl_Color;
    fogDistance = length(viewPos.xyz);
#if (VISUAL_STYLE > 0 || CUBIC_CELESTIALS == 1 || CLOUD_STYLE == 1) && defined(SKY_BASIC) && !defined(NO_SHADOW)
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
    vec3 lightingNormal = worldNormal;
#if defined(WET_GROUND_PASS) && VISUAL_STYLE > 0
    // Keep the geometric normal for shadow receiver placement. Only lighting
    // uses the ground-facing normal so adjacent plant cards share grass-top light.
    if (mc_Entity.x > 10002.5 && mc_Entity.x < 10005.5) lightingNormal = vec3(0.0, 1.0, 0.0);
#endif
    vec3 lightWorld = mat3(gbufferModelViewInverse) * normalize(shadowLightPosition);
    lightCosine = dot(lightingNormal, lightWorld);
    ambientHemisphere = 0.82 + 0.18 * max(lightingNormal.y, 0.0);
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
