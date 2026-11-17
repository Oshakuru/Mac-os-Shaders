<p align="center"><img src="assets/branding/metal-vintage.png" width="240" alt="Vintage M logo from the Metal era"></p>

# macOS Shaders

Minecraft Java Edition visual pack developed around Apple Silicon, with selectable art styles, shadows, procedural water and rain puddles.

**Latest update: macOS Shaders 1.9** (16 November 2026)

- Pro preset set to the author's in-game settings.
- Wet ground reflections off by default and in all presets, for performance.
- Metal-era code names renamed to macOS Shaders.
- Miyazaki Skybox cloud style removed; the SDV Skybox cloud style is now called macOS Skybox.
- Moon gets a round halo instead of square bloom, plus moonbeams, moon rays and a moon-tinted lens flare at night (Pro and Pro Max).
- Nether portal is brighter and self-lit, so it glows purple with bloom.
- Builder runs the source checks before packaging and makes repeatable ZIPs.

See [release notes](RELEASE-NOTES.md) and [compatibility notes](COMPATIBILITY.md).

## Current features

- Vanilla, Miyazaki and Dark Fantasy art styles.
- Air, Pro and Pro Max quality presets.
- macOS Skybox clouds by default (adapted from Super Duper Vanilla by Eldeston), with Fading Clouds and Vanilla available.
- SDV-style moonlit nights with per-style colours, and optional soft Miyazaki outlines.
- Original blended water with depth fog, procedural waves and Off / Sky / Sky + Shore / Screen-space reflections.
- Rain-driven puddles with rain ripples and wet-ground darkening. Wet ground reflections (Sky or Sky + Scene) are optional and off by default.
- Embedded cubic sun/moon support, including eight moon phases, when built with the separately supplied assets.
- Vertex sunbeam setup and sparse depth reconstruction optimizations.
- Organized settings under Performance, Style, Lighting, Atmosphere and Other.

Fresh Water and Fresh Rain were experimental and are removed from the current code. Rain/snow and particle sprites use the game's textures; the Unobtrusive Weather option only lowers their opacity.

## Compatibility and testing

Developed on **Apple M1, Minecraft 1.21.11 and Iris 1.10.4**. Version 1.5 was also tested in game by the developer on **Minecraft 1.20.1 and 26.3**, the two ends of the supported range; versions in between are covered by source checks only. On 26.2 and 26.3 set Graphics API to Prefer OpenGL. OptiFine compatibility has not been verified. macOS Shaders is a GLSL/Iris pack, not a native Apple Metal renderer, and is not affiliated with or endorsed by Apple.

The developer confirmed that Fading Clouds (formerly Story Mode clouds), both optimization switches, and Sky + Scene puddle reflections work with good performance. The approximately 215 FPS result belongs to an earlier optimized baseline, not a benchmark guarantee for the current pack. See [validation notes](docs/VALIDATION.md).

## Build and install

This repository contains the source and development history. GitHub's automatic source ZIP is not an installable shaderpack.

Build using Python 3 and a local copy of **Cubic Sun & Moon v1.8.5 by JoeFly**:

```sh
python3 tools/build.py --cubic-pack "/path/to/cubic-sun-moon-v1.8.5.zip"
```

The cubic images carry an all-rights-reserved notice and are not uploaded here. The build script reads them from your local archive; no separate in-game resource pack is required. Alternatively, build with the existing game celestial option:

```sh
python3 tools/build.py --without-cubic
```

Place both generated files from `dist/` into Minecraft's `shaderpacks` folder and select **macOS-Shaders-v1.9.zip** in Iris. The matching settings file is the author's in-game configuration, which the Pro preset now matches: shadow strength 1.0, shadow bias 1.4, sunbeams at 0.30 with 4 steps, one SDV cloud layer at 0.8 opacity, screen-space water reflections with 4 steps, rain puddles and ripples off and Unobtrusive weather on.

For visible terrain/lava reflections select **Atmosphere → Puddles and Wet Ground → Wet ground reflections → Sky + Scene**. Sky mode reflects only the sky and can be subtle on dark rainy nights.

## Development history

Saved versions are imported as chronological source snapshots in Git history. These imports preserve old names, including Metal and M1-Light, and known failures; they do not pretend to be the original historical commit dates. See [CHANGELOG.md](CHANGELOG.md) and [history index](docs/HISTORY.md).

The progression runs from **M1-Light 0.5.5** through the 0.8 experiments, **Metal 1.0**, the cleanup and Iris fixes, and the tested **Metal 0.9** baseline, then the macOS Shaders releases up to **1.7**. The **1.8** and **1.9** updates are recorded in the history index as source updates without a GitHub release. Earlier broken snapshots are retained for development reference.

### Versions

| Version | Name | What was added | Status |
|---|---|---|---|
| 1.9 | Pro preset and polish | Pro preset set to the author's in-game settings; wet ground reflections off by default; Miyazaki Skybox clouds removed and SDV Skybox renamed macOS Skybox; round moon halo with moonbeams and lens flare; purple nether portal glow; Metal-era code renamed to macOS Shaders; builder runs the checks and writes repeatable ZIPs | Tested in game; not released |
| 1.8 | SDV-style nights | Stronger moonlight and lower night fill (moonlit ground about 5x brighter than shade); Miyazaki Skybox cloud style; rain ripples near the player and on puddles | Tested in game; not released |
| 1.7 | Moonlight and soft outlines | Direct moonlight +20%; optional soft Miyazaki depth outlines | GitHub prerelease (v1.7) |
| 1.6 | Style water tones | Water tone and fog follow the art style (Dark Fantasy muddy, Miyazaki light blue); Miyazaki contrast +20% | GitHub tag v1.6 |
| 1.5 | Multiversion patch 2 | Minecraft 26.1, 26.2 and 26.3 support; files renamed from Metal to macOS Shaders | GitHub tag v1.5 |
| 1.4 | Multiversion patch 1 | Minecraft 1.20.1–1.21.11 support; texture-free Unobtrusive Weather | Earlier version |
| 1.3 | New water | Original lightweight blended water replacing the MakeUp adaptation | Earlier version |
| 1.2 | Sun and sunbeams | Sunbeam rework, screen-space sun rays, lens flare, sun size | Earlier version |
| 1.1 | Bloom | Tight bloom on light sources | Earlier version |
| 1.0 | Rename | Metal 1.2 renamed to macOS Shaders; no rendering changes | Earlier version |

Before the rename the pack was **Metal** (0.9 to 1.2) and, earlier, **M1-Light** (0.5.5 to 0.8). Their notes are in [CHANGELOG.md](CHANGELOG.md) and [docs/HISTORY.md](docs/HISTORY.md).

### Saved snapshots

These source snapshots were imported in development order on 2026-11-10. The import does not backdate commits. Snapshots 1–26 run from M1-Light 0.5.5 to the Metal 0.9 baseline; 27 and 28 are macOS Shaders 1.8 and 1.9. Versions in between are in the version table and the changelog.

Restricted cubic and historical Fresh texture images are omitted from the public snapshots; original filenames, source, attribution notices and status are retained. See THIRD_PARTY_NOTICES.md and the [JSON index](docs/history-index.json) for omitted assets.

| Order | Snapshot | Status | Source |
|---|---|---|---|
| 1 | M1-Light v0.5.5 | Historical snapshot; not the current release | [view commit](https://github.com/Oshakuru/metal/commit/8591d962fded47c6edac52dbe17735d707defd57) |
| 2 | M1-Light v0.5.6 | Historical snapshot; not the current release | [view commit](https://github.com/Oshakuru/metal/commit/b770e21abc192442569f5eb645340cc8d5183761) |
| 3 | M1-Light v0.6 | Historical snapshot; not the current release | [view commit](https://github.com/Oshakuru/metal/commit/743906c94faaf98161825e75747f978fb0545eb5) |
| 4 | M1-Light v0.6.1 | Historical snapshot; not the current release | [view commit](https://github.com/Oshakuru/metal/commit/474d4a4dfcc8ba270da4c64fe4078e29ff1ca3a9) |
| 5 | M1-Light v0.6.2 | Historical snapshot; not the current release | [view commit](https://github.com/Oshakuru/metal/commit/277bd5bf11a496e5720c881e8d3828617cb0a288) |
| 6 | M1-Light v0.6.3 | Historical snapshot; not the current release | [view commit](https://github.com/Oshakuru/metal/commit/138f882c5b9dd0c7f390ed2ffde54992756dfd44) |
| 7 | M1-Light v0.7 | Historical snapshot; not the current release | [view commit](https://github.com/Oshakuru/metal/commit/ef08c411c3e834b74bfa47de1537e04f20587797) |
| 8 | M1-Light v0.8 baseline | User-selected visual/performance baseline | [view commit](https://github.com/Oshakuru/metal/commit/73cfadf0bac36bc2a7fd5102911969ebe020739f) |
| 9 | M1-Light v0.8.1 atmosphere experiment | User reported 20–30 FPS below v0.8; rejected as baseline | [view commit](https://github.com/Oshakuru/metal/commit/36f1688ffa96f02f483cd92f15052920d58dca5c) |
| 10 | M1-Light v0.8 settings layout | Complementary-inspired menu organization | [view commit](https://github.com/Oshakuru/metal/commit/a486f1651bb9a9e0a0b2fc56d8d9c071630451e5) |
| 11 | M1-Light v0.8 Apple optimization experiment | User confirmed sunbeam gain and 203 to 215 FPS average with sparse reconstruction | [view commit](https://github.com/Oshakuru/metal/commit/a7a18cb5b03c3278712fd57f04a35d461abacfcf) |
| 12 | M1-Light v0.8 Story Mode clouds | User confirmed cloud appearance and maintained performance | [view commit](https://github.com/Oshakuru/metal/commit/09e129e6227b0e4f856e251184e87bf0e74d6f1e) |
| 13 | Cartoon palette study | Unreleased palette study, superseded by the reference-led Storybook style | [view commit](https://github.com/Oshakuru/metal/commit/075d1847e1333979d963fa024ca0f212b254f24f) |
| 14 | Cartoon Storybook | Ni no Kuni and user-supplied animation references | [view commit](https://github.com/Oshakuru/metal/commit/66906b34c516eaca2838067de77cae8d06fb5203) |
| 15 | Dark Fantasy Grim | Colder shadows and more subdued atmosphere | [view commit](https://github.com/Oshakuru/metal/commit/f6a27b9e23d4d9f407d29171e5296f9ec7ce27a8) |
| 16 | Cubic Sun and Moon integration | Embedded-sprite integration; restricted textures excluded from public history | [view commit](https://github.com/Oshakuru/metal/commit/af992dda919e2ff608702b4f52eb06130c1131fb) |
| 17 | Fresh Water and Rain experiment | Superseded; water/rain texture assets excluded from public history | [view commit](https://github.com/Oshakuru/metal/commit/33d52b11c544603d03177501f025d81ef34e7f36) |
| 18 | Photon water adaptation | Replaces Fresh Water with waves, absorption and sky reflections | [view commit](https://github.com/Oshakuru/metal/commit/213085512480f067ed0a223b7e7b26cd83f65357) |
| 19 | Photon puddles and wet ground | Removes Fresh Rain; adds puddles and optional scene reflections | [view commit](https://github.com/Oshakuru/metal/commit/a8e1f11e1d14544f167a6cc89628475cc880495f) |
| 20 | Rename M1-Light to Metal 1.0 | Former branding/version, later relabeled 0.9; contained two Iris loading issues | [view commit](https://github.com/Oshakuru/metal/commit/e47874b056cd3271569cd697927b1f508fb3d7c0) |
| 21 | Metal 1.0 cleanup candidate | Shared helpers and conditional work elimination; contained Iris metadata issues | [view commit](https://github.com/Oshakuru/metal/commit/5dae7c08a670eb4bcd45e20b3a757bd6bc7762c2) |
| 22 | Metal 1.0 Iris clear-color fix | Four-component clear color; RGBA8 issue still present | [view commit](https://github.com/Oshakuru/metal/commit/e15247c60611a7bef6ee0d402d0f725add87aef1) |
| 23 | Metal cleanup Iris clear-color fix | Four-component clear color; RGBA8 issue still present | [view commit](https://github.com/Oshakuru/metal/commit/9e05935d68dc3e35a7b1ce5c95c9b1187f888028) |
| 24 | Metal 1.0 Iris format fix | User confirmed pack loads after both Iris fixes | [view commit](https://github.com/Oshakuru/metal/commit/227345b21fa43574a7923d0bd22deaab9553a08e) |
| 25 | Metal cleanup Iris format fix | User confirmed loading and working Sky + Scene puddle reflections | [view commit](https://github.com/Oshakuru/metal/commit/7e7458d7240e47f735f8a5e7b7cbadfeac82f6c1) |
| 26 | Metal 0.9 current tested baseline | Current version; user confirmed reflections and good performance | [view commit](https://github.com/Oshakuru/metal/commit/661f96bdbc6953dc0847f422fd43af0f8af58020) |
| 27 | macOS Shaders 1.8 | SDV-style nights, Miyazaki Skybox clouds, rain ripple fix; tested in game by the author, not released | [view commit](https://github.com/Oshakuru/Mac-os-Shaders/commit/3ee7f8f) |
| 28 | macOS Shaders 1.9 | Pro preset from the author's settings, wet ground reflections off, macOS Shaders naming, builder fixes; tested in game by the author, not released | [view commit](https://github.com/Oshakuru/Mac-os-Shaders/commit/d49e247) |

Snapshots 27 and 28 are historical updates recorded after the published 1.7 release. They have no GitHub release; build them from source with tools/build.py.

### Pre-1.0 release notes

#### 0.9.1 weather and ripples

> Superseded in 1.4: Unobtrusive Weather no longer embeds or replaces textures. The option now fades the game's own rain and snow to 35% opacity, so no weather archive is needed. The paragraph below describes the 0.9.1 behaviour.

Supply Unobtrusive Weather v2.0 with `--weather-pack` to embed its rain and snow in the generated shaderpack. No additional in-game resource pack or Particle Rain mod is needed. Without that build input, vanilla weather is selected automatically. Textures are not included in the public repository because the supplied archive contains no redistribution license notice.

Atmosphere → Weather toggles the embedded weather. Atmosphere → Water contains Rain ripples and their strength. Ripples require the pack's custom water, appear during rain, and use skylight as an approximate outdoor mask. They are an original Metal effect rather than Particle Rain's Java particles. Particle splash sprites remain vanilla.

See [release notes](RELEASE-NOTES.md) for the pending in-game checks. Iris uses Minecraft's limited legacy text colors for these labels; the exact requested RGB gradient strings are retained in `assets/branding/preset-labels.json`.

#### Skybox clouds in 0.9.2

- Replaced Fading Clouds with original two-layer skybox clouds, independent of terrain render distance. Vanilla remains selectable. Matches the reference active skybox mode's angular horizon fade: clear sky fades from y=0.1 to y=0.2667; rain raises and softens that fade. Uses an original generated cloud mask, not reference-pack code or assets. No settings title was added.

#### 0.9.3 visual polish

Cloud masks now have filtered continuous edges, smaller separated islands and four fixed texture reads instead of the previous 16. The skybox horizon fade is unchanged. Green terrain is selectively dimmed and desaturated in Miyazaki and Dark Fantasy; Vanilla is unchanged. In-game appearance and FPS require comparison.

#### 0.9.4 sky and vegetation

Restores the tested Fading Clouds, removes the experimental skybox cloud renderer, and uses a broad celestial sky-background treatment inspired by Super Duper Vanilla with Metal's own Miyazaki/Dark Fantasy palettes. This is an original implementation rather than copied reference-pack source. Grass/fern lighting uses an upward-facing normal so crossed plant planes no longer receive orientation-dependent direct light. Shadow receiver normals remain geometric. The broad 0.9.3 green albedo adjustment is removed. In-game matching and performance still need verification.

#### 0.9.5 water replacement

Water now adapts MakeUp Ultra Fast 9.6 by Javier Garduño (LGPL-3.0), including its scrolling wave texture, depth absorption and squared Fresnel blend. Metal adds a dedicated opaque scene snapshot and a bounded scene-reflection trace. This is an adaptation to Metal's lighting/color/buffer pipeline, not a promise of pixel-identical output. Photon-derived ground puddles remain separate. See THIRD_PARTY_NOTICES.md.

#### SDV skybox clouds in 0.9.5

- Default clouds now use Super Duper Vanilla v1.3.8's adapted skybox parallax renderer and original cloud map, with Metal's preset tones. Fading Clouds remain selectable as option 2; Vanilla is option 0. Matches the reference skybox mapping and horizon fade independently of terrain render distance. Compositing is adapted to Metal's LDR pipeline; the overall SDV bloom/tone-mapping pipeline is not included.

#### 0.9.6 water binding fix

Moves the opaque scene snapshot from colortex2 to colortex4. Iris only binds scene targets 4+ in gbuffers passes; the old water sampler was unbound and sampled the block atlas. The skybox and its preset tones are unchanged.

#### 0.9.7 lightweight foliage wind

Performance settings include Foliage wind and Wind strength. Wind uses two sine evaluations per moving vertex, no added texture reads, fragment work, buffers or draw passes. Motion fades between 24 and 48 horizontal blocks; beyond 48 the trigonometry is skipped. Short plant bases and tall lower roots are anchored; tall halves share the same seam displacement. Leaves move subtly. The same helper moves shadow casters. Disable wind to compile out the animation path. This describes the implementation cost, not a measured FPS guarantee; test the same scene with wind on/off.

#### 0.9.8 quality ladder

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

#### 0.9.9 refinement

Adds low-contribution reflection trace skipping, refined water-hit rejection, separate entity/block-entity shadow controls, optional spatial edge smoothing, and neutral-by-default brightness/contrast/saturation/green controls. No bloom. Half-resolution reflection rendering remains deferred until the current water is confirmed stable in-game, as proposed in the review; it needs a dedicated reflection pass and depth-aware reconstruction rather than merely lowering sample count.

#### 0.9.10 — three presets

| New tier | Starting configuration |
|---|---|
| Air | Former Pro: 512 shadows at 48 blocks, one cloud layer, no reflections, AO or sunbeams |
| Pro | User's saved 0.9.9 Custom state, with FXAA disabled |
| Pro Max | Former Pro Max Plus, with FXAA disabled |

The old Air and old Pro Max tiers are retired. Pro has 512 shadows at 64 blocks, four-tap filtering, two 16-step cloud layers, AO, sunbeams and independent lighting; water reflections use six trace steps, refraction and wind are off. Pro retains the supplied brightness 0.8 and saturation 1.2. Unlisted settings were reconstructed from the installed 0.9.9 shader defaults. FXAA remains available manually but is off in all three presets. Art style stays independent; the supplied settings retain Dark Fantasy. Other tracked changes, including grading changes, display Custom. Earlier four-tier comparisons and 25% targets describe previous releases and no longer define this ladder.

#### 0.9.11 wet-ground Sky mode

Sky (Light), formerly Sky (Fast), uses flat puddle normals and gates low-coverage/low-contribution pixels before sky reflection shading. It fades reflections earlier (40–96 block caps, also limited by render distance). Puddle coverage and wet darkening remain intact. The existing mask/deferred-pass bandwidth cost remains; no fixed FPS improvement is promised. Water and skybox rendering are unchanged. For a controlled comparison use the same preset, position, direction, weather and time, changing only Wet ground reflections between Off, Sky (Light), and Sky + Scene. The shipped Pro configuration retains its previous Sky + Scene setting; select Sky (Light) explicitly for the new path.

#### 0.9.12 settings labels

Performance-related settings use standard Minecraft colors: green for low, yellow for medium, red for high potential impact. Mixed-cost categories show the higher tier; actual cost depends on mode, active effects and scene coverage. Strength/color sliders are low arithmetic cost; lowering intensity alone generally does not disable the effect. Existing descriptive tooltips and impact category text remain. DARK FANTASY and MIYAZAKI are plain unformatted ASCII labels. Rendering and preset values are unchanged.

#### 0.9.13 Pro refresh

Pro now reconstructs the user's latest 0.9.12 Custom configuration: wind enabled, AO disabled, cloud depth 8 steps, Sky water/wet reflections, shadow distance 48 blocks. Other installed defaults are preserved, including refraction/FXAA off and brightness 0.8/saturation 1.2. Air and Pro Max are unchanged. Art-style labels remain standard Minecraft ALL CAPS, now red for DARK FANTASY and light blue for MIYAZAKI.

#### 0.9.14 reflection resolution

Performance → Water → Wet reflection resolution selects Half or Full. Half uses a genuinely half-width/half-height reflection target (quarter pixel count) with a separate full-resolution combination pass. Upscaling rejects depth-discontinuous samples and uses the full-resolution wet mask to keep reflections off dry objects. Rejected samples retain base shading. Air/Pro use Half; Pro Max uses Full. Reflection Off disables the reflection pass; the water snapshot combination pass remains when custom water is on. Water shaders and skybox are unchanged. Added pipeline/buffer overhead means FPS gains must be measured, not inferred from the quarter pixel count.

Player shadow is separate in Performance → Shadows. Included Pro settings use Player shadow On, Mob/entity shadows Off, Block entity shadows Off. Terrain shadows remain enabled. All presets keep the local player shadow on; Pro Max additionally retains mob and block-entity shadows.

#### 0.9.15 source cleanup

Consolidates repeated deferred shaders into shared implementations, tidies shader whitespace and formats quality profiles into readable blocks. Required dimension entry points are retained. All 110 expanded shader entry points match the 0.9.14 baseline ignoring whitespace; rendering algorithms, presets and assets are unchanged. See docs/CODE-AUDIT-0.9.14.md for the audit and deferred optimization candidates.

## To do

- Vanilla-style rework of lava and the nether portal.
- Distant Horizons compatibility.

## Contributing and licensing

The repository's existing GPLv3 `LICENSE` is retained. Third-party source and assets retain their own notices and terms; the root license does not relicense them. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the Photon and Story Mode adaptations and externally supplied cubic textures. Current third-party dependencies should be reviewed before repackaging or publishing through other distribution services.

Run `python3 tools/validate.py` before packaging. In-game testing remains necessary for Iris patching, buffer behavior, appearance and frame times.

## Multiversion compatibility patches 1.4 and 1.5

Patch 1.4 adds Minecraft Java 1.20.1–1.21.11 compatibility; patch 1.5 extends it to 26.1, 26.2 and 26.3 with Iris on OpenGL. Later versions retain these compatibility mappings. See [compatibility notes](COMPATIBILITY.md) for requirements, changes and testing status. This build does not include Distant Horizons support.
