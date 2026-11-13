<p align="center"><img src="assets/branding/metal-vintage.png" width="240" alt="Vintage M logo from the Metal era"></p>

# macOS Shaders

Minecraft Java Edition visual pack developed around Apple Silicon, with selectable art styles, shadows, procedural water and rain puddles.

**In development: macOS Shaders 1.2**, not yet released. The pack was formerly called Metal; macOS Shaders 1.0 is Metal 1.2 under the new name, 1.1 added bloom, and 1.2 adds reworked sunbeams, screen-space sun rays and a warmer Dark Fantasy palette. See [release notes](RELEASE-NOTES.md).

## Current features

- Vanilla, Miyazaki and Dark Fantasy art styles.
- Air, Pro and Pro Max quality presets.
- SDV skybox clouds by default, with Fading Clouds and Vanilla available.
- MakeUp Ultra Fast-derived water waves, depth absorption, refraction and Sky + Scene reflections.
- Rain-driven puddles, wet-ground darkening and optional Sky + Scene reflections.
- Embedded cubic sun/moon support, including eight moon phases, when built with the separately supplied assets.
- Vertex sunbeam setup and sparse depth reconstruction optimizations.
- Organized settings under Performance, Style, Lighting, Atmosphere and Other.

Fresh Water and Fresh Rain were experimental and are removed from the current code. Rain/snow and particle sprites use the game's textures.

## Compatibility and testing

Tested by the developer on **Apple M1, Minecraft 1.21.11 and Iris 1.10.4**. OptiFine compatibility has not been verified. macOS Shaders is a GLSL/Iris pack, not a native Apple Metal renderer, and is not affiliated with or endorsed by Apple.

The developer confirmed that Fading Clouds (formerly Story Mode clouds), both optimization switches, and Sky + Scene puddle reflections work with good performance. The approximately 215 FPS result belongs to an earlier optimized baseline, not a benchmark guarantee for the current pack. See [validation notes](docs/VALIDATION.md).

## Build and install

This repository contains the source and development history. GitHub's automatic source ZIP is not an installable shaderpack.

Build using Python 3 and a local copy of **Cubic Sun & Moon v1.8.5 by JoeFly**:

```sh
python3 tools/build.py --cubic-pack "/path/to/cubic-sun-moon-v1.8.5.zip" --weather-pack "/path/to/Unobtrusive Weather.zip"
```

The cubic images carry an all-rights-reserved notice and are not uploaded here. The build script reads them from your local archive; no separate in-game resource pack is required. Alternatively, build with the existing game celestial option:

```sh
python3 tools/build.py --without-cubic
```

Place both generated files from `dist/` into Minecraft's `shaderpacks` folder and select **macOS-Shaders-v1.2.zip** in Iris. The matching settings file preserves the author's supplied Custom configuration, including Dark Fantasy, AO at 8 samples, sunbeam strength 0.22 and 8 steps, and MakeUp water disabled.

For visible terrain/lava reflections select **Atmosphere → Puddles and Wet Ground → Wet ground reflections → Sky + Scene**. Sky mode reflects only the sky and can be subtle on dark rainy nights.

## Development history

Saved versions are imported as chronological source snapshots in Git history. These imports preserve old names, including Metal and M1-Light, and known failures; they do not pretend to be the original historical commit dates. See [CHANGELOG.md](CHANGELOG.md) and [history index](docs/HISTORY.md).

The progression runs from **M1-Light 0.5.5** through the 0.8 experiments, **Metal 1.0**, the cleanup and Iris fixes, and finally the tested **Metal 0.9** baseline. Earlier broken snapshots are retained for development reference.

## Contributing and licensing

The repository's existing GPLv3 `LICENSE` is retained. Third-party source and assets retain their own notices and terms; the root license does not relicense them. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the Photon and Story Mode adaptations and externally supplied cubic textures. Current third-party dependencies should be reviewed before repackaging or publishing through other distribution services.

Run `python3 tools/validate.py` before packaging. In-game testing remains necessary for Iris patching, buffer behavior, appearance and frame times.

## 0.9.1 weather and ripples

Supply Unobtrusive Weather v2.0 with `--weather-pack` to embed its rain and snow in the generated shaderpack. No additional in-game resource pack or Particle Rain mod is needed. Without that build input, vanilla weather is selected automatically. Textures are not included in the public repository because the supplied archive contains no redistribution license notice.

Atmosphere → Weather toggles the embedded weather. Atmosphere → Water contains Rain ripples and their strength. Ripples require MakeUp water and Water reflections, appear during rain, and use skylight as an approximate outdoor mask. They are an original Metal effect rather than Particle Rain's Java particles. Particle splash sprites remain vanilla.

See [release notes](RELEASE-NOTES.md) for the pending in-game checks. Iris uses Minecraft's limited legacy text colors for these labels; the exact requested RGB gradient strings are retained in `assets/branding/preset-labels.json`.

## Skybox clouds in 0.9.2

- Replaced Fading Clouds with original two-layer skybox clouds, independent of terrain render distance. Vanilla remains selectable. Matches the reference active skybox mode's angular horizon fade: clear sky fades from y=0.1 to y=0.2667; rain raises and softens that fade. Uses an original generated cloud mask, not reference-pack code or assets. No settings title was added.

## 0.9.3 visual polish

Cloud masks now have filtered continuous edges, smaller separated islands and four fixed texture reads instead of the previous 16. The skybox horizon fade is unchanged. Green terrain is selectively dimmed and desaturated in Miyazaki and Dark Fantasy; Vanilla is unchanged. In-game appearance and FPS require comparison.

## 0.9.4 sky and vegetation

Restores the tested Fading Clouds, removes the experimental skybox cloud renderer, and uses a broad celestial sky-background treatment inspired by Super Duper Vanilla with Metal's own Miyazaki/Dark Fantasy palettes. This is an original implementation rather than copied reference-pack source. Grass/fern lighting uses an upward-facing normal so crossed plant planes no longer receive orientation-dependent direct light. Shadow receiver normals remain geometric. The broad 0.9.3 green albedo adjustment is removed. In-game matching and performance still need verification.

## 0.9.5 water replacement

Water now adapts MakeUp Ultra Fast 9.6 by Javier Garduño (LGPL-3.0), including its scrolling wave texture, depth absorption and squared Fresnel blend. Metal adds a dedicated opaque scene snapshot and a bounded scene-reflection trace. This is an adaptation to Metal's lighting/color/buffer pipeline, not a promise of pixel-identical output. Photon-derived ground puddles remain separate. See THIRD_PARTY_NOTICES.md.

## SDV skybox clouds in 0.9.5

- Default clouds now use Super Duper Vanilla v1.3.8's adapted skybox parallax renderer and original cloud map, with Metal's preset tones. Fading Clouds remain selectable as option 2; Vanilla is option 0. Matches the reference skybox mapping and horizon fade independently of terrain render distance. Compositing is adapted to Metal's LDR pipeline; the overall SDV bloom/tone-mapping pipeline is not included.

## 0.9.6 water binding fix

Moves the opaque scene snapshot from colortex2 to colortex4. Iris only binds scene targets 4+ in gbuffers passes; the old water sampler was unbound and sampled the block atlas. The skybox and its preset tones are unchanged.

## 0.9.7 lightweight foliage wind

Performance settings include Foliage wind and Wind strength. Wind uses two sine evaluations per moving vertex, no added texture reads, fragment work, buffers or draw passes. Motion fades between 24 and 48 horizontal blocks; beyond 48 the trigonometry is skipped. Short plant bases and tall lower roots are anchored; tall halves share the same seam displacement. Leaves move subtly. The same helper moves shadow casters. Disable wind to compile out the animation path. This describes the implementation cost, not a measured FPS guarantee; test the same scene with wind on/off.

## 0.9.8 quality ladder

| Setting | Air | Pro | Pro Max | Pro Max Plus |
|---|---|---|---|---|
| Shadows | Off | 512 / 48 blocks / 1 tap | 1024 / 64 blocks / 4 taps | 2048 / 80 blocks / 9 taps |
| Cloud layers × depth steps | 1 × 4 | 1 × 8 | 2 × 16 | 2 × 32 |
| Water | Game | MakeUp refraction | MakeUp refraction + scene reflections | MakeUp refraction + higher-quality scene reflections |
| Water reflection trace steps | Off | Off | 8 | 16 |
| Wet ground | Off | Darkening, no reflections | Sky + Scene | Sky + Scene |
| AO | Off | Off | 4 samples | 8 samples |
| Sunbeams | Off | Off | 4 samples | 8 samples |
| Foliage wind | Off | On | On | On |

Air disables other optional effects such as custom celestial sprites, custom weather and water ripples. It retains the requested single low-cost cloud layer and the selected art palette. Apple optimizations remain enabled in every tier. Pro Max Plus enables all implemented production effects; it does not enable debug modes or maximize aesthetic slider strengths.

The tuning targets Pro at approximately 1.25× Pro Max FPS, and Pro Max at approximately 1.25× Pro Max Plus FPS. These are unmeasured targets, not benchmark results. If Plus achieves 100 FPS, the corresponding targets are Max 125 and Pro 156.25. Compare all presets from the same position, camera angle, weather, time, resolution and render distance after chunk loading settles. Scene content and CPU/GPU limits can change the gaps. The included settings file selects Pro Max.

Performance is a dedicated tuning hub with impact-labelled groups for shadows, clouds, water, lighting effects and foliage. Tooltips explain the largest costs. Every control in this hub is included in each quality profile, so a changed value displays Iris's Custom label; restoring a complete matching profile restores its name. Art style is intentionally independent. Public builds without optional external textures keep those unavailable replacements disabled in every profile.

## 0.9.9 refinement

Adds low-contribution reflection trace skipping, refined water-hit rejection, separate entity/block-entity shadow controls, optional spatial edge smoothing, and neutral-by-default brightness/contrast/saturation/green controls. No bloom. Half-resolution reflection rendering remains deferred until the current water is confirmed stable in-game, as proposed in the review; it needs a dedicated reflection pass and depth-aware reconstruction rather than merely lowering sample count.

## 0.9.10 — three presets

| New tier | Starting configuration |
|---|---|
| Air | Former Pro: 512 shadows at 48 blocks, one cloud layer, no reflections, AO or sunbeams |
| Pro | User's saved 0.9.9 Custom state, with FXAA disabled |
| Pro Max | Former Pro Max Plus, with FXAA disabled |

The old Air and old Pro Max tiers are retired. Pro has 512 shadows at 64 blocks, four-tap filtering, two 16-step cloud layers, AO, sunbeams and independent lighting; water reflections use six trace steps, refraction and wind are off. Pro retains the supplied brightness 0.8 and saturation 1.2. Unlisted settings were reconstructed from the installed 0.9.9 shader defaults. FXAA remains available manually but is off in all three presets. Art style stays independent; the supplied settings retain Dark Fantasy. Other tracked changes, including grading changes, display Custom. Earlier four-tier comparisons and 25% targets describe previous releases and no longer define this ladder.

## 0.9.11 wet-ground Sky mode

Sky (Light), formerly Sky (Fast), uses flat puddle normals and gates low-coverage/low-contribution pixels before sky reflection shading. It fades reflections earlier (40–96 block caps, also limited by render distance). Puddle coverage and wet darkening remain intact. The existing mask/deferred-pass bandwidth cost remains; no fixed FPS improvement is promised. Water and skybox rendering are unchanged. For a controlled comparison use the same preset, position, direction, weather and time, changing only Wet ground reflections between Off, Sky (Light), and Sky + Scene. The shipped Pro configuration retains its previous Sky + Scene setting; select Sky (Light) explicitly for the new path.

## 0.9.12 settings labels

Performance-related settings use standard Minecraft colors: green for low, yellow for medium, red for high potential impact. Mixed-cost categories show the higher tier; actual cost depends on mode, active effects and scene coverage. Strength/color sliders are low arithmetic cost; lowering intensity alone generally does not disable the effect. Existing descriptive tooltips and impact category text remain. DARK FANTASY and MIYAZAKI are plain unformatted ASCII labels. Rendering and preset values are unchanged.

## 0.9.13 Pro refresh

Pro now reconstructs the user's latest 0.9.12 Custom configuration: wind enabled, AO disabled, cloud depth 8 steps, Sky water/wet reflections, shadow distance 48 blocks. Other installed defaults are preserved, including refraction/FXAA off and brightness 0.8/saturation 1.2. Air and Pro Max are unchanged. Art-style labels remain standard Minecraft ALL CAPS, now red for DARK FANTASY and light blue for MIYAZAKI.

## 0.9.14 reflection resolution

Performance → Water → Wet reflection resolution selects Half or Full. Half uses a genuinely half-width/half-height reflection target (quarter pixel count) with a separate full-resolution combination pass. Upscaling rejects depth-discontinuous samples and uses the full-resolution wet mask to keep reflections off dry objects. Rejected samples retain base shading. Air/Pro use Half; Pro Max uses Full. Reflection Off disables the reflection pass; the water snapshot combination pass remains when custom water is on. Water shaders and skybox are unchanged. Added pipeline/buffer overhead means FPS gains must be measured, not inferred from the quarter pixel count.

Player shadow is separate in Performance → Shadows. Included Pro settings use Player shadow On, Mob/entity shadows Off, Block entity shadows Off. Terrain shadows remain enabled. All presets keep the local player shadow on; Pro Max additionally retains mob and block-entity shadows.

## 0.9.15 source cleanup

Consolidates repeated deferred shaders into shared implementations, tidies shader whitespace and formats quality profiles into readable blocks. Required dimension entry points are retained. All 110 expanded shader entry points match the 0.9.14 baseline ignoring whitespace; rendering algorithms, presets and assets are unchanged. See docs/CODE-AUDIT-0.9.14.md for the audit and deferred optimization candidates.
