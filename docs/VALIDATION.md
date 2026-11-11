# Validation record

The source audit compiled 3,731 selected program configurations per original/cleanup build on the native Apple M1 GLSL 120 driver and compared 72 synthetic renders. Those checks did not exercise Iris's loader or patched OpenGL 4.1 code path.

Two assumptions were subsequently corrected using the live Iris error log:

1. `colortex1ClearColor` requires an explicit four-component constructor for Iris's metadata parser.
2. RGBA8 is not a GLSL built-in. Its format directive belongs in a block comment; test harnesses must not inject an RGBA8 definition that hides an undeclared identifier.

After both corrections, 150 program configurations per build passed direct-driver compilation without the injected constant. The user subsequently confirmed loading in Iris 1.10.4, visible puddle reflections in Sky + Scene mode and good performance.

The earlier approximately 215 FPS measurement describes a previous optimized baseline. No precise current-release FPS claim is made.

Current limits: coarse screen-space reflections miss offscreen/occluded objects; camera-biome wetness can mismatch at borders/altitude; water RGB absorption is approximated through alpha blending; sky reflections omit cloud/cubic sprite details. In-game tests remain necessary.

## 0.9.1

New weather sampling and original rain-ring normals require in-game verification. Prior 0.9 performance/visual confirmations do not validate this revision. Exact RGB chat-plugin syntax is not supported in Iris language strings; the requested originals are preserved separately, with legacy-color menu approximations.

Native Apple M1 OpenGL 2.1 driver: 150 program checks compiled and linked successfully across all three art styles and dimensions. This does not replace Iris loading and in-game weather/visual testing.
Additional 150 targeted water/reflection/ripple/wave/weather option combinations compiled and linked with zero failures. Public fallback builds disable missing weather/cubic texture features automatically.

0.9.2 skybox replacement requires in-game checks for sky coverage, terrain occlusion, day/night/weather, underwater behavior and performance. Previous Fading Clouds confirmations do not cover this renderer.

Skybox renderer: all 150 standard native-driver program checks passed on Apple M1.
