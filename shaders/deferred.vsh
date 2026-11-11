#version 120
#include "/lib/daylight.glsl"
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
varying vec2 uv;
varying vec3 wetSunWorld;
varying vec2 wetTimeOfDay;
void main() {
    gl_Position = ftransform();
    uv = gl_MultiTexCoord0.xy;
    wetSunWorld = mat3(gbufferModelViewInverse) * normalize(sunPosition);
    wetTimeOfDay = vec2(daylightFactor(wetSunWorld.y), twilightFactor(wetSunWorld.y));
}
