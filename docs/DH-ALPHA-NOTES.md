# macOS Shaders 1.3 DH alpha 1

Based on the supplied v1.3 pack. Adds terrain and water programs for the Overworld,
Nether and End, reusing its lighting, water palette and visual styles.
Normal distance fog extends to DH distance; short-range medium/status fog stays local.
DH water thickness uses DH opaque depth, and near water can see the distant floor.
Distant geometry blocks screen-space sun rays and lens flare.

Limitations: no DH cast shadows, distant puddles, distant AO or distant screen-space
reflections. Distant water uses sky reflections. LOD color/lighting and the transition
need in-game validation. Shader compilation checks do not replace Iris/DH testing.

Select macOS-Shaders-v1.3-DH-alpha1.zip in Iris. Keep the original pack as a fallback.
Target instance: Minecraft 1.21.11, Iris 1.10.4, Distant Horizons 3.3.3.

Reference reviewed: Complementary Reimagined r5.9.3 by EminGT
(https://www.complementary.dev/). No Complementary implementation code is included;
its supplied license imposes incompatible whole-pack licensing conditions.
Near-depth occlusion for distant water and DH cloud suppression were independently
implemented against the Iris interface after checking that reference.

## Alpha 2: daylight calibration

Adds DH Daylight Brightness under Lighting Settings, default 0.80. Adjusts
Overworld opaque LOD surfaces after lighting and before fog, fading out at night
and around strong block light. 1.0 restores alpha 1 brightness. This is an
empirical calibration for reported bright daytime LODs, not a measured albedo fix.
