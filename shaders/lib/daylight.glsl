#ifndef METAL_DAYLIGHT
#define METAL_DAYLIGHT
float daylightFactor(float sunHeight) {
    return smoothstep(-0.08, 0.12, sunHeight);
}
float twilightFactor(float sunHeight) {
    return (1.0 - smoothstep(0.04, 0.32, abs(sunHeight)))
         * smoothstep(-0.14, 0.04, sunHeight);
}
#endif
