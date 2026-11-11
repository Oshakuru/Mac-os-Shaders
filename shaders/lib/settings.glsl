const int shadowMapResolution = 1024; // [512 1024 2048]
const float shadowDistance = 48.0; // [32.0 48.0 64.0 80.0]
const float shadowDistanceRenderMul = 1.0;
const float shadowIntervalSize = 2.0;
const bool shadowHardwareFiltering = false;
const bool shadowtex0Nearest = true;
#define SHADOW_STRENGTH 0.85 // [0.35 0.50 0.70 0.85 1.0]
#define SHADOW_FILTER 1 // [0 1 2]
#define AMBIENT_LIGHT 0.58 // [0.35 0.48 0.58 0.70 0.80]
#define TORCH_FALLOFF 2 // [1 2 3]
#define SHADOW_BIAS 1.0 // [0.6 1.0 1.4]
#define DEBUG_VIEW 0 // [0 1 2 3]

#define RECEIVER_CORRECTION 1 // [0 1]

#define NIGHT_AMBIENT 0.58 // [0.35 0.48 0.58 0.70 0.75 0.80]
#define MOON_CONTRAST 0.45 // [0.15 0.25 0.45 0.65 1.0]

#define VISUAL_STYLE 0 // [0 1 2]
#define DARK_STYLE_STRENGTH 1.0 // [0.0 0.5 0.75 1.0]
#define DARK_HAZE 0.30 // [0.0 0.15 0.30 0.45]

#define DARK_LIGHT_TINT 0.50 // [0.0 0.20 0.35 0.50]

#define CARTOON_STRENGTH 1.0 // [0.0 0.5 0.75 1.0]

#define MAX_AO 0 // [0 1]
#define MAX_SUNBEAMS 0 // [0 1]
#define MAX_AO_STRENGTH 0.22 // [0.0 0.12 0.22 0.32]
#define MAX_SUNBEAM_STRENGTH 0.15 // [0.0 0.08 0.15 0.22]
