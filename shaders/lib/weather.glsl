// Preserve the game's rain/snow selection, including resource-pack textures.
#if defined(WEATHER_PASS) && UNOBTRUSIVE_WEATHER == 1
vec4 metalWeatherTexture() {
    vec4 weather = texture2D(texture, uv);
    weather.a *= 0.35;
    return weather;
}
#endif
