# Third-party components

## Photon v1.4 — Benjamin Stott / SixthSurge

Water and rain-puddle implementations were adapted for this pack's GLSL 120 pipeline. Photon credits Belmu for its wave-function basis. The original puddle-noise image is retained.

Affected paths include `shaders/lib/photon_water.glsl`, `shaders/lib/wet_ground.glsl`, `shaders/textures/photon/puddle_noise.png` and related reflection integration. Original terms are preserved in `licenses/Photon-License.txt`; these components are not represented as newly relicensed by the root GPL license.

## Story Mode Clouds — not_thefirst and tixul

Cloud geometry/fading is adapted to the Iris cloud program. Original MIT notice is retained in `licenses/Story-Mode-Clouds-MIT.txt`.

## Cubic Sun & Moon v1.8.5 — JoeFly

The original copyright notice is retained in `licenses/Cubic-Sun-Moon.txt`. Source textures are not uploaded to this public repository or its imported history. `tools/build.py --cubic-pack` can read a separately obtained local copy to assemble the existing shader integration.

## Historical Fresh Water / Fresh Rain experiments

The code experiment is preserved in imported source history, but its user-supplied water/rain images are omitted. The current build removes this feature. Those historical snapshots are not complete redistributable texture packages.

## Original work and references

This project was named Metal until it was renamed macOS Shaders; "Metal" below and in source comments refers to this project. Metal's original contributions use the repository's existing license. Ni no Kuni and user-supplied animation images guided palette decisions; trailers and reference images are not included. The logo and alternate concepts were generated during project development; the vintage M is the selected identity. No Apple logo is included.

## Unobtrusive Weather v2.0 — supplied archive

Only rain.png and snow.png are read from the user's local ZIP by tools/build.py. The supplied archive has no author/license notice; no redistribution permission is inferred. These images are omitted from GitHub. Particle Rain-specific and splash textures are not integrated.

## MakeUp Ultra Fast 9.6 — Javier Garduño

Water adaptation in shaders/lib/makeup_water.glsl, related interface/integration files, and shaders/textures/makeup/water_256_RG_8bit.png. Original wave sampling, rational absorption and reflection treatment adapted for Metal's GLSL 120 LDR pipeline and opaque snapshot; the bounded reflection trace and rain-ring integration are modified for Metal. Distributed with corresponding editable shader source, the root GPLv3 text and licenses/MakeUp-UltraFast-LGPL-3.0.txt. Original project: https://github.com/javiergcim/MakeUpUltraFast . Modified 2026-11-10. Photon now supplies only ground-puddle components, not the current water renderer.

## Super Duper Vanilla v1.3.8 — Eldeston / FlameRender (C) Studios

The adapted skybox parallax functions in shaders/lib/sdv_clouds.glsl and the original shaders/textures/sdv/clouds.png retain the FlameRender (C) Studios License v1.6, copied in licenses/Super-Duper-Vanilla-FlameRender.txt. They are not relicensed under the root GPL. Modified for GLSL 120 texture sampling, Metal preset tones and LDR cloud compositing on 2026-11-10. Original project: https://github.com/Eldeston/Super-Duper-Vanilla . The root GPL applies to Metal-authored portions; third-party components retain their stated licenses.
