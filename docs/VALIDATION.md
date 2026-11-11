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

## 0.9.3

User screenshots showed stepped/merged clouds and overly bright grass in both art styles. This revision changes cloud filtering/masks/composition and green terrain albedo. In-game confirmation is pending.

## 0.9.4

User rejected the skybox-cloud experiment and reported persistent grass/foliage mismatch. Restored Fading Clouds; new sky-background shaping and upward plant lighting require in-game confirmation.

## 0.9.5

Water renderer and scene snapshot are new. Test shorelines, glass over water, underwater entry, caves, dimensions, reflection screen edges, rain rings and FPS in Iris. Native compilation does not validate framebuffer bindings or visual parity.

0.9.5 additionally replaces default geometry clouds with the adapted SDV skybox renderer and original mask. Check reference cloud shape/range, preset tones, underwater hiding, cloud-mode switching and FPS in game.

## 0.9.6

User confirmed the SDV skybox looks good but water displayed a block-atlas mosaic. IrisSamplers.addRenderTargetSamplers explicitly starts at color target 4 for non-fullscreen passes. The water used target 2 and therefore had an unbound scene sampler. Native shader compilation missed this. Fixed both snapshot output and sampler to target 4; added a static pipeline-binding check. Iris source: https://github.com/IrisShaders/Iris/blob/1.21.11/common/src/main/java/net/irisshaders/iris/samplers/IrisSamplers.java .

Offscreen M1 regression: when only Iris-supported gbuffers scene samplers are bound, the old water fails to reproduce an input scene gradient (delta 0.0); repaired water reproduces it (delta 0.4487). 156 standard shader programs compiled/linked with no failures. This is a simulated binding/render test, not in-game Iris confirmation.

## 0.9.7

Foliage wind adds no texture/framebuffer/pass resources. Validate grass roots, tall-plant seam continuity, leaf connections, shadow alignment, crop age geometry and motion/fps with wind toggled. No in-game result yet.

M1 verification: 156 standard compile/link checks and 24 wind-toggle/style/puddle checks passed. Offscreen GPU execution confirmed anchored short/tall roots, equal tall-half seam offsets, moving plant tops, smaller leaf movement and zero movement beyond 48 blocks. No in-game FPS benchmark performed.
