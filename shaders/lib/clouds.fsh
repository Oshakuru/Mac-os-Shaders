#include "/lib/settings.glsl"
uniform sampler2D texture;
uniform vec3 fogColor;
uniform float fogStart;
uniform float fogEnd;
uniform float far;
uniform int isEyeInWater;
varying vec4 cloudTint;
varying vec2 cloudUV;
varying vec3 cloudPlayerPosition;
varying float cloudLayerHeight;
varying float cloudObserverHeight;
/* DRAWBUFFERS:0 */
void main() {
    vec4 texel = texture2D(texture, cloudUV);
    vec4 color = texel * cloudTint;
#if CLOUD_STYLE == 1 && !defined(NO_CUSTOM_CLOUDS)
    // Story Mode adaptation: flatter cloud face lighting and a shorter layer.
    // Retain the game's time/weather cloud tint; lift face contrast toward it.
    float faceLight = max(max(cloudTint.r, cloudTint.g), cloudTint.b);
    vec3 flatTint = mix(cloudTint.rgb, vec3(faceLight), 0.65);
    color.rgb = texel.rgb * flatTint;
    float observer = clamp(-cloudObserverHeight / 10.0, -1.0, 1.0);
    float fadeBelow = 1.0 - cloudLayerHeight;
    float fadeAbove = cloudLayerHeight;
    float fade = mix(fadeBelow, fadeAbove, (observer + 1.0) * 0.5);
    color.a *= clamp(0.8 - fade, 0.0, 1.0) * CLOUD_OPACITY;
#endif
#if CLOUD_STYLE > 0 && !defined(NO_CUSTOM_CLOUDS)
    // Cloud distance is horizontal: terrain fog must not erase high clouds.
    float cloudEnd = max(far, 256.0);
    float fog = smoothstep(cloudEnd * 0.5, cloudEnd, length(cloudPlayerPosition.xz));
    color.a *= 1.0 - fog;
    if (isEyeInWater != 0) color.a = 0.0;
#else
    float fog = clamp((length(cloudPlayerPosition) - fogStart) / max(fogEnd - fogStart, 0.001), 0.0, 1.0);
    color.rgb = mix(color.rgb, fogColor, fog);
#endif
    // The supplied Story Mode fade can go negative; clamp before blending.
    color.a = clamp(color.a, 0.0, 1.0);
    gl_FragData[0] = color;
}
