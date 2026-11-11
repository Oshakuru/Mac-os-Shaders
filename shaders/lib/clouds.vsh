#include "/lib/settings.glsl"
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform float cloudHeight;
varying vec4 cloudTint;
varying vec2 cloudUV;
varying vec3 cloudPlayerPosition;
varying float cloudLayerHeight;
varying float cloudObserverHeight;
void main() {
    vec4 view = gl_ModelViewMatrix * gl_Vertex;
    vec3 player = (gbufferModelViewInverse * view).xyz;
    cloudLayerHeight = 0.0;
    cloudObserverHeight = cameraPosition.y - cloudHeight;
#if CLOUD_STYLE > 0 && !defined(NO_CUSTOM_CLOUDS)
    // Iris supplies the vanilla cloud plane in world coordinates.
    // Vanilla Fancy geometry is four blocks tall; stretch only that height.
    float localHeight = player.y + cameraPosition.y - cloudHeight;
    cloudLayerHeight = clamp(localHeight / 4.0, 0.0, 1.0);
    float thickness = 10.0;
    player.y += cloudLayerHeight * (thickness - 4.0);
    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(player, 1.0);
#else
    gl_Position = gl_ProjectionMatrix * view;
#endif
    cloudPlayerPosition = player;
    cloudTint = gl_Color;
    cloudUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
