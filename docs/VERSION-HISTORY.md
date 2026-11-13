# macOS Shaders version history

What was done in each version and why. Rule: each new feature adds 0.1, and stable releases take the next whole number (see `VERSIONING.md`). Work on `rebrand-macos-shaders-1.0`, 12–13 November 2026.

## 1.0 — Rebrand

- **What:** renamed Metal to macOS Shaders. Metal 1.2's rendering is unchanged.
- **Build output:** `macOS-Shaders-v<version>.zip` plus a matching `config/macOS-Shaders-v<version>.zip.txt`.
- **Disclaimer:** README and release notes say the pack is not affiliated with Apple and is not an Apple Metal renderer.
- **Kept on purpose:** internal `metal…` GLSL names, the Metal history docs and the old Metal settings files.
- **Also:** added project-only Claude Code skills in `.claude/skills/`: ponytail, graphify and shader-programming. All were malware-checked and copied as skill files only, with no hooks. Superpowers and ECC were rejected.

## 1.1 — Bloom

- **Why:** a glow around light sources, like the Dark Fantasy references. It must stay tight; the author dislikes the blurry bloom of other packs.
- **What:**
  - new `composite.fsh` in all three dimensions keeps only the brightest pixels (threshold on the brightest colour channel) in colortex6
  - `final_main.glsl` adds two mip levels of that back (8 taps), before the colour grade
- **Options:** Bloom, Bloom strength (0.10 / 0.25 / 0.40), Bloom threshold (0.80 / 0.90 / 0.95). Off in Air, on in Pro and Pro Max.
- **Files:**
  - `lib/bloom_pass.glsl`
  - `lib/bloom_vertex.glsl`
  - `composite.*` (all three dimensions)
  - `lib/final_main.glsl`
  - settings, properties and lang

## 1.2 — Sunbeams, sun rays, lens flare, sun size

- **Why:** the references have strong visible shafts. Raising the strength alone didn't help, and canopies showed almost nothing.
- **Shadow-map shafts** (`pro_max.glsl`):
  - shadowed air is now dimmed as well as lit air brightened, so beams separate from the shade
  - wider angle and denser air
  - strength up to 0.40, blend cap raised from 0.25 to 0.40
- **Screen-space sun rays:** 16 depth samples towards the sun on screen, so light streams through gaps in leaves. The author called the result "amazing".
- **Lens flare:** four small, hard-edged ghosts mirrored through the screen centre, fading as the sun is blocked (5-tap visibility). Needs sunbeams on.
- **Sun size:** new option, 75% by default. Scales the game's sun quad (`scene.fsh`) and the Cubic sun (`cubic_celestials.glsl`).
- **Performance:** shadow-space transforms bracketed as matrix-vector chains (`pro_max.glsl`, `scene.vsh`). Same image, less maths per pixel and per vertex.
- **Preset change:** Pro took the author's saved settings at the time (AO 0.32), and Dark Fantasy became the default style.
- **Reverted:** a trial warmer olive palette. The author prefers the original Dark Fantasy tones.

## 1.3 — New water

- **Why:** the MakeUp-derived water and its reflections were too expensive. The author asked for a fresh start, using Mellow 3.5's water as a reference for good looks at low cost.
- **What** (original code in `lib/water.glsl` and `lib/water.vsh`; design studied from Mellow, which is MIT-licensed, and no Mellow code is included):
  - ordinary blended water, with no full-screen refraction copy
  - depth fog from depthtex1: clear shallows, opaque depths (`WATER_FOG`)
  - a gentle world-space swell in the vertex shader
  - four-wave procedural ripples, calmed with distance; rain ripples kept
  - Fresnel-weighted reflections with a sun glint
- **Reflection levels:** Off / Sky / Sky + Shore (one scene sample) / Screen-space (8 steps, refinement only at glancing angles). Air is Off, Pro is Sky, Pro Max is Screen-space.
- **Scene copy:** the colortex4 copy is only made for Sky + Shore and Screen-space.
- **Removed:** refraction, Water absorption, the MakeUp wave texture and its LGPL licence file.
- **Pro preset:** now the author's latest saved settings (`config/macOS-Shaders-v1.3.zip.txt`): sunbeams 0.40 with 6 steps, Sky water reflections, half-resolution wet-ground reflections, AO 0.32 and Dark Fantasy. These are also the shader defaults.
- **Author's verdict:** looks good, but a little too realistic. Make it more stylised next session.

## Test status

- Validators and the fallback build pass for every version.
- None of the 1.1–1.3 code has been through a GLSL compiler; the author has checked it in game only.
- Open issues:
  - white specks on the player model at night (cause unknown)
  - puddles disappear in dry biomes, because Iris reports the camera's biome
