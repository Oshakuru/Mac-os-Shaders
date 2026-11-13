#ifndef M1_SETTINGS_INCLUDED
#define M1_SETTINGS_INCLUDED
const int shadowMapResolution = 512; // [512 1024 2048]
const float shadowDistance = 48.0; // [32.0 48.0 64.0 80.0]
const float shadowDistanceRenderMul = 1.0;
const float shadowIntervalSize = 2.0;
const bool shadowHardwareFiltering = false;
const bool shadowtex0Nearest = true;
#define SHADOWS 1 // [0 1]
#define SHADOW_STRENGTH 0.85 // [0.35 0.50 0.70 0.85 1.0]
#define SHADOW_FILTER 1 // [0 1 2]
#define AMBIENT_LIGHT 0.58 // [0.35 0.48 0.58 0.70 0.80]
#define TORCH_FALLOFF 2 // [1 2 3]
#define SHADOW_BIAS 1.0 // [0.6 1.0 1.4]
#define DEBUG_VIEW 0 // [0 1 2 3]

#define RECEIVER_CORRECTION 1 // [0 1]

#define NIGHT_AMBIENT 0.58 // [0.35 0.48 0.58 0.70 0.75 0.80]
#define MOON_CONTRAST 0.45 // [0.15 0.25 0.45 0.65 1.0]

#define VISUAL_STYLE 1 // [0 1 2]
#define DARK_STYLE_STRENGTH 1.0 // [0.0 0.5 0.75 1.0]
#define DARK_HAZE 0.30 // [0.0 0.15 0.30 0.45]

#define DARK_LIGHT_TINT 0.50 // [0.0 0.20 0.35 0.50]

#define CARTOON_STRENGTH 1.0 // [0.0 0.5 0.75 1.0]

#define MAX_AO 1 // [0 1]
#define MAX_SUNBEAMS 1 // [0 1]
#define MAX_AO_QUALITY 1 // [1 2]
#define SUNBEAM_STEPS 4 // [4 6 8]
#define MAX_AO_STRENGTH 0.32 // [0.0 0.12 0.22 0.32]
#define MAX_SUNBEAM_STRENGTH 0.15 // [0.0 0.08 0.15 0.22 0.30 0.40]

#define MAX_LIGHTING 1 // [0 1]

#define BLOOM 1 // [0 1]
#define BLOOM_STRENGTH 0.25 // [0.10 0.25 0.40]
#define BLOOM_THRESHOLD 0.90 // [0.80 0.90 0.95]

#define APPLE_SUN_SETUP 1 // [0 1]
#define APPLE_DEPTH_RECONSTRUCTION 1 // [0 1]

#define CLOUD_STYLE 1 // [0 1 2]
#define SDV_CLOUD_STEPS 8 // [4 8 16 32]
#define SDV_CLOUD_LAYERS 2 // [1 2]
#define CLOUD_OPACITY 1.0 // [0.4 0.6 0.8 1.0]

#define CUBIC_CELESTIALS 1 // [0 1]

#define MAKEUP_WATER 1 // [0 1]
#define WATER_REFRACTION 0 // [0 1]
#define WATER_ABSORPTION 0.10 // [0.02 0.06 0.10 0.20 0.40]
#define WATER_WAVE_STRENGTH 1.0 // [0.0 0.5 1.0 1.5]
#define WATER_SSR_STEPS 6 // [6 8 10 16]
#define WATER_REFLECTIONS 2 // [0 1 2]
#define RAIN_PUDDLES 1 // [0 1]
#define WET_REFLECTION_RESOLUTION 1 // [0 1]
#define WET_GROUND_REFLECTIONS 1 // [0 1 2]

#define UNOBTRUSIVE_WEATHER 1 // [0 1]
#define RAIN_RIPPLES 1 // [0 1]
#define RAIN_RIPPLE_STRENGTH 0.6 // [0.0 0.3 0.6 1.0]

#define FOLIAGE_WIND 1 // [0 1]
#define FOLIAGE_WIND_STRENGTH 0.5 // [0.0 0.5 1.0]

#define PLAYER_SHADOW 1 // [0 1]
#define ENTITY_SHADOWS 0 // [0 1]
#define BLOCK_ENTITY_SHADOWS 0 // [0 1]
#define FXAA 0 // [0 1]
#define GRADE_BRIGHTNESS 0.8 // [0.8 0.9 1.0 1.1 1.2]
#define GRADE_CONTRAST 1.0 // [0.8 0.9 1.0 1.1 1.2]
#define GRADE_SATURATION 1.2 // [0.6 0.8 1.0 1.1 1.2]
#define GRADE_GREEN_SATURATION 1.0 // [0.6 0.8 1.0 1.1 1.2]
#endif
