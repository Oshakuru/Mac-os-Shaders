#include "/lib/settings.glsl"
#include "/lib/daylight.glsl"
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform float cloudHeight;
#if VISUAL_STYLE == 2
uniform vec3 sunPosition;
varying vec3 cartoonCloudTint;
#endif
varying vec4 cloudTint;
varying vec2 cloudUV;
varying vec3 cloudPlayerPosition;
varying float cloudLayerHeight;
varying float cloudObserverHeight;
void main() {
    vec4 view = gl_ModelViewMatrix * gl_Vertex;
    vec3 player = (gbufferModelViewInverse * view).xyz;
    cloudObserverHeight = cameraPosition.y - cloudHeight;
    // Iris supplies the vanilla cloud plane in world coordinates.
    // Vanilla Fancy geometry is four blocks tall; stretch only that height.
    float localHeight = player.y + cameraPosition.y - cloudHeight;
    cloudLayerHeight = clamp(localHeight / 4.0, 0.0, 1.0);
    float thickness = 10.0;
    player.y += cloudLayerHeight * (thickness - 4.0);
    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(player, 1.0);
    cloudPlayerPosition = player;
    cloudTint = gl_Color;
#if VISUAL_STYLE == 2
    float sunHeight = (mat3(gbufferModelViewInverse) * normalize(sunPosition)).y;
    vec3 painted = mix(vec3(0.81, 0.94, 1.10), vec3(1.035, 1.02, 0.94), daylightFactor(sunHeight));
    painted = mix(painted, vec3(1.08, 0.94, 0.83), twilightFactor(sunHeight) * 0.65);
    cartoonCloudTint = mix(vec3(1.0), painted, CARTOON_STRENGTH);
#endif
    cloudUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
