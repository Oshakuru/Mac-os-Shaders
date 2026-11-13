# Third-party components

## Photon v1.4 — Benjamin Stott / SixthSurge

The rain-puddle implementation was adapted for this pack's GLSL 120 pipeline. The original puddle-noise image is retained. The earlier Photon-derived water (`shaders/lib/photon_water.glsl`) has been removed; current water is original code, see the Mellow section below.

Affected paths include `shaders/lib/wet_ground.glsl`, `shaders/textures/photon/puddle_noise.png` and related reflection integration. Original terms are preserved in `licenses/Photon-License.txt`; these components are not represented as newly relicensed by the root GPL license.

## Story Mode Clouds — not_thefirst and tixul

Cloud geometry/fading is adapted to the Iris cloud program. Original MIT notice is retained in `licenses/Story-Mode-Clouds-MIT.txt`.

## Cubic Sun & Moon v1.8.5 — JoeFly

The original copyright notice is retained in `licenses/Cubic-Sun-Moon.txt`. Source textures are not uploaded to this public repository or its imported history. `tools/build.py --cubic-pack` can read a separately obtained local copy to assemble the existing shader integration.

## Historical Fresh Water / Fresh Rain experiments

The code experiment is preserved in imported source history, but its user-supplied water/rain images are omitted. The current build removes this feature. Those historical snapshots are not complete redistributable texture packages.

## Original work and references

This project was named Metal until it was renamed macOS Shaders; "Metal" below and in source comments refers to this project. Metal's original contributions use the repository's existing license. Ni no Kuni and user-supplied animation images guided palette decisions; trailers and reference images are not included. The logo and alternate concepts were generated during project development; the vintage M is the selected identity. No Apple logo is included.

## Unobtrusive Weather v2.0 — supplied archive

Since macOS Shaders 1.4 the pack uses no Unobtrusive Weather files. The setting of that name only lowers the opacity of the game's own rain and snow textures in shaders/lib/weather.glsl, which is original code. Earlier versions read rain.png and snow.png from the user's local ZIP at build time; the supplied archive has no author/license notice, no redistribution permission was inferred, and those images were never uploaded to GitHub.

## Mellow by TheCMK (MIT) — design reference only

The water in shaders/lib/water.glsl and water.vsh is original code written for this project. Its approach (blended water instead of a refraction copy, depth-based opacity, Fresnel-weighted reflections and a one-sample reflection mode) was studied from Mellow 3.5 by TheCMK, released under the MIT License (Copyright (c) 2026 TheCMK). No Mellow code or assets are included. Project: https://codeberg.org/TheCMK/mellow-shader

The earlier MakeUp Ultra Fast water adaptation, its wave texture and its LGPL-3.0 licence file were removed in macOS Shaders 1.3.

## Super Duper Vanilla v1.3.8 — Eldeston / FlameRender (C) Studios

The adapted skybox parallax functions in shaders/lib/sdv_clouds.glsl and the original shaders/textures/sdv/clouds.png retain the FlameRender (C) Studios License v1.6, copied in licenses/Super-Duper-Vanilla-FlameRender.txt. They are not relicensed under the root GPL. Modified for GLSL 120 texture sampling, Metal preset tones and LDR cloud compositing on 2026-11-10. Original project: https://github.com/Eldeston/Super-Duper-Vanilla . The root GPL applies to Metal-authored portions; third-party components retain their stated licenses.
