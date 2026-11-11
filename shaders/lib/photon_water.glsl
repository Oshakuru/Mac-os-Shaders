// Water adaptation informed by Photon v1.4, SixthSurge / Benjamin Stott.
// The squared-sine wave model originates in Photon (credited there to Belmu).
// Adapted to GLSL 120 with three analytic slopes instead of sampled finite differences.
// Photon license retained in licenses/Photon-License.txt.
#if PHOTON_WATER == 1 && defined(PHOTON_WATER_PASS)
uniform float frameTimeCounter;
uniform sampler2D depthtex1;
uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 skyColor;
uniform vec3 cameraPosition;
#if VISUAL_STYLE == 0
uniform int isEyeInWater;
#ifndef WORLD_LIGHTING
uniform float rainStrength;
#endif
#endif
varying float photonWaterMask;
varying vec3 photonWorldPosition;
varying vec3 photonWorldNormal;
varying vec3 photonViewPosition;
varying vec3 photonSunDirection;
varying vec2 photonTimeOfDay;
vec3 photonWaveNormal(vec3 flatNormal) {
    vec3 n = normalize(flatNormal);
    if (abs(n.y) < 0.5 || WATER_WAVE_STRENGTH <= 0.0) return n;
    vec2 direction = vec2(0.8660254, 0.5);
    mat2 rotation = mat2(-0.7373689, 0.6754903, -0.6754903, -0.7373689);
    vec2 coord = photonWorldPosition.xz;
    float frequency = 0.7;
    float wavelength = 1.0;
    float amplitude = 1.0;
    vec2 slope = vec2(0.0);
    float t = frameTimeCounter * 0.5;
    for (int i = 0; i < 3; i++) {
        float k = 6.2831853 / wavelength;
        float phase = sqrt(9.8 * k) * t - k * dot(direction, coord * frequency);
        // Analytic derivative of (sin(phase) * .5 + .5)^2.
        slope += -k * frequency * direction * (sin(phase) * 0.5 + 0.5) * cos(phase) * amplitude;
        amplitude *= 0.5;
        frequency *= 1.7;
        wavelength *= 1.5;
        direction = rotation * direction;
    }
    vec3 worldView = normalize(cameraPosition - photonWorldPosition);
    float grazingFade = smoothstep(0.0, 0.15, abs(dot(n, worldView)));
    slope *= (0.04 + 0.08 * rainStrength) * WATER_WAVE_STRENGTH * grazingFade / 1.75;
    return normalize(n + vec3(-slope.x, 0.0, -slope.y));
}
vec4 samplePhotonWater() {
    // Smooth water body color.
    return vec4(0.16, 0.48, 0.52, 1.0);
}
float photonLinearDepth(float z) {
    return near * far / max(far - z * (far - near), 0.0001);
}
vec4 applyPhotonWater(vec4 litColor) {
    if (isEyeInWater != 0) return litColor;
    vec3 flatNormal = normalize(photonWorldNormal);
    vec3 n = photonWaveNormal(flatNormal);
    vec3 v = normalize(cameraPosition - photonWorldPosition);
    if (dot(n, v) < 0.0) n = -n;
    float NoV = clamp(dot(n, v), 0.0, 1.0);
    vec2 screenUV = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float opaqueDepth = texture2D(depthtex1, screenUV).r;
    float eyeSurface = photonLinearDepth(gl_FragCoord.z);
    float thickness = clamp((photonLinearDepth(opaqueDepth) - eyeSurface)
        * length(photonViewPosition) / max(abs(photonViewPosition.z), 0.01), 0.0, 64.0);
    // Photon default RGB absorption coefficients, scaled for this LDR pipeline.
    vec3 transmission = exp(-vec3(0.39, 0.14, 0.07) * thickness);
    float bodyAlpha = clamp(1.0 - dot(transmission, vec3(0.2126, 0.7152, 0.0722)), 0.025, 0.96);
    vec3 absorptionTint = mix(vec3(1.0), vec3(0.48, 0.85, 1.0), 1.0 - transmission.r);
    vec3 body = litColor.rgb * absorptionTint;
    float fresnel = 0.0;
    vec3 reflected = vec3(0.0);
#if WATER_REFLECTIONS == 1
    float edge = 1.0 - NoV;
    float edge2 = edge * edge;
    fresnel = 0.0204 + 0.9796 * edge2 * edge2 * edge;
    vec3 r = reflect(-v, n);
    float exposure = smoothstep(0.1, 0.85, lm.y);
#if VISUAL_STYLE == 1 && !defined(NO_SHADOW)
    reflected = fantasySky(r, photonSunDirection, photonTimeOfDay.x, photonTimeOfDay.y, rainStrength);
#elif VISUAL_STYLE == 2 && !defined(NO_SHADOW)
    reflected = cartoonSky(r, photonSunDirection, photonTimeOfDay.x, photonTimeOfDay.y, rainStrength);
#else
    reflected = mix(fogColor, skyColor, smoothstep(0.0, 0.8, max(r.y, 0.0)));
#endif
    reflected *= exposure;
    float highlight = pow(max(dot(r, normalize(photonSunDirection)), 0.0), 128.0)
        * exposure * photonTimeOfDay.x * (1.0 - rainStrength * 0.7);
    reflected += vec3(1.0, 0.93, 0.78) * highlight * 2.0;
#endif
    float alpha = bodyAlpha * (1.0 - fresnel) + fresnel;
    vec3 premultiplied = body * bodyAlpha * (1.0 - fresnel) + reflected * fresnel;
    return vec4(clamp(premultiplied / max(alpha, 0.001), 0.0, 1.0), alpha);
}
#endif
