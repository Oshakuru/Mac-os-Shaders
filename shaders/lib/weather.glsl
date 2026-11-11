// Unobtrusive Weather v2.0 textures supplied locally at build time.
#if defined(WEATHER_PASS) && UNOBTRUSIVE_WEATHER == 1
uniform sampler2D metalRainTexture;
uniform sampler2D metalSnowTexture;
vec4 metalWeatherTexture() {
    if (weatherIsRain > 0.5) return texture2D(metalRainTexture, uv);
    return texture2D(metalSnowTexture, uv);
}
#endif
