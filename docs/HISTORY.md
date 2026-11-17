# Saved development history

These source snapshots were imported in development order on 2026-11-10. The import does not backdate commits. Current baseline: **Metal 0.9**; future versions: **0.9.1**, **0.9.2**.

Restricted cubic and historical Fresh texture images are omitted from the public snapshots; original filenames, source, attribution notices and status are retained. See THIRD_PARTY_NOTICES.md and the JSON index for omitted assets.

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


# Pre-1.0 release notes (moved from README in 1.9)

### 0.9.1 weather and ripples

> Superseded in 1.4: Unobtrusive Weather no longer embeds or replaces textures. The option now fades the game's own rain and snow to 35% opacity, so no weather archive is needed. The paragraph below describes the 0.9.1 behaviour.

Supply Unobtrusive Weather v2.0 with `--weather-pack` to embed its rain and snow in the generated shaderpack. No additional in-game resource pack or Particle Rain mod is needed. Without that build input, vanilla weather is selected automatically. Textures are not included in the public repository because the supplied archive contains no redistribution license notice.

Atmosphere → Weather toggles the embedded weather. Atmosphere → Water contains Rain ripples and their strength. Ripples require the pack's custom water, appear during rain, and use skylight as an approximate outdoor mask. They are an original Metal effect rather than Particle Rain's Java particles. Particle splash sprites remain vanilla.

See [release notes](RELEASE-NOTES.md) for the pending in-game checks. Iris uses Minecraft's limited legacy text colors for these labels; the exact requested RGB gradient strings are retained in `assets/branding/preset-labels.json`.

### Skybox clouds in 0.9.2

- Replaced Fading Clouds with original two-layer skybox clouds, independent of terrain render distance. Vanilla remains selectable. Matches the reference active skybox mode's angular horizon fade: clear sky fades from y=0.1 to y=0.2667; rain raises and softens that fade. Uses an original generated cloud mask, not reference-pack code or assets. No settings title was added.

### 0.9.3 visual polish

Cloud masks now have filtered continuous edges, smaller separated islands and four fixed texture reads instead of the previous 16. The skybox horizon fade is unchanged. Green terrain is selectively dimmed and desaturated in Miyazaki and Dark Fantasy; Vanilla is unchanged. In-game appearance and FPS require comparison.

### 0.9.4 sky and vegetation

Restores the tested Fading Clouds, removes the experimental skybox cloud renderer, and uses a broad celestial sky-background treatment inspired by Super Duper Vanilla with Metal's own Miyazaki/Dark Fantasy palettes. This is an original implementation rather than copied reference-pack source. Grass/fern lighting uses an upward-facing normal so crossed plant planes no longer receive orientation-dependent direct light. Shadow receiver normals remain geometric. The broad 0.9.3 green albedo adjustment is removed. In-game matching and performance still need verification.

### 0.9.5 water replacement

Water now adapts MakeUp Ultra Fast 9.6 by Javier Garduño (LGPL-3.0), including its scrolling wave texture, depth absorption and squared Fresnel blend. Metal adds a dedicated opaque scene snapshot and a bounded scene-reflection trace. This is an adaptation to Metal's lighting/color/buffer pipeline, not a promise of pixel-identical output. Photon-derived ground puddles remain separate. See THIRD_PARTY_NOTICES.md.

### SDV skybox clouds in 0.9.5

- Default clouds now use Super Duper Vanilla v1.3.8's adapted skybox parallax renderer and original cloud map, with Metal's preset tones. Fading Clouds remain selectable as option 2; Vanilla is option 0. Matches the reference skybox mapping and horizon fade independently of terrain render distance. Compositing is adapted to Metal's LDR pipeline; the overall SDV bloom/tone-mapping pipeline is not included.

### 0.9.6 water binding fix

Moves the opaque scene snapshot from colortex2 to colortex4. Iris only binds scene targets 4+ in gbuffers passes; the old water sampler was unbound and sampled the block atlas. The skybox and its preset tones are unchanged.

### 0.9.7 lightweight foliage wind

Performance settings include Foliage wind and Wind strength. Wind uses two sine evaluations per moving vertex, no added texture reads, fragment work, buffers or draw passes. Motion fades between 24 and 48 horizontal blocks; beyond 48 the trigonometry is skipped. Short plant bases and tall lower roots are anchored; tall halves share the same seam displacement. Leaves move subtly. The same helper moves shadow casters. Disable wind to compile out the animation path. This describes the implementation cost, not a measured FPS guarantee; test the same scene with wind on/off.

### 0.9.8 quality ladder

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

### 0.9.9 refinement

Adds low-contribution reflection trace skipping, refined water-hit rejection, separate entity/block-entity shadow controls, optional spatial edge smoothing, and neutral-by-default brightness/contrast/saturation/green controls. No bloom. Half-resolution reflection rendering remains deferred until the current water is confirmed stable in-game, as proposed in the review; it needs a dedicated reflection pass and depth-aware reconstruction rather than merely lowering sample count.

### 0.9.10 — three presets

| New tier | Starting configuration |
|---|---|
| Air | Former Pro: 512 shadows at 48 blocks, one cloud layer, no reflections, AO or sunbeams |
| Pro | User's saved 0.9.9 Custom state, with FXAA disabled |
| Pro Max | Former Pro Max Plus, with FXAA disabled |

The old Air and old Pro Max tiers are retired. Pro has 512 shadows at 64 blocks, four-tap filtering, two 16-step cloud layers, AO, sunbeams and independent lighting; water reflections use six trace steps, refraction and wind are off. Pro retains the supplied brightness 0.8 and saturation 1.2. Unlisted settings were reconstructed from the installed 0.9.9 shader defaults. FXAA remains available manually but is off in all three presets. Art style stays independent; the supplied settings retain Dark Fantasy. Other tracked changes, including grading changes, display Custom. Earlier four-tier comparisons and 25% targets describe previous releases and no longer define this ladder.

### 0.9.11 wet-ground Sky mode

Sky (Light), formerly Sky (Fast), uses flat puddle normals and gates low-coverage/low-contribution pixels before sky reflection shading. It fades reflections earlier (40–96 block caps, also limited by render distance). Puddle coverage and wet darkening remain intact. The existing mask/deferred-pass bandwidth cost remains; no fixed FPS improvement is promised. Water and skybox rendering are unchanged. For a controlled comparison use the same preset, position, direction, weather and time, changing only Wet ground reflections between Off, Sky (Light), and Sky + Scene. The shipped Pro configuration retains its previous Sky + Scene setting; select Sky (Light) explicitly for the new path.

### 0.9.12 settings labels

Performance-related settings use standard Minecraft colors: green for low, yellow for medium, red for high potential impact. Mixed-cost categories show the higher tier; actual cost depends on mode, active effects and scene coverage. Strength/color sliders are low arithmetic cost; lowering intensity alone generally does not disable the effect. Existing descriptive tooltips and impact category text remain. DARK FANTASY and MIYAZAKI are plain unformatted ASCII labels. Rendering and preset values are unchanged.

### 0.9.13 Pro refresh

Pro now reconstructs the user's latest 0.9.12 Custom configuration: wind enabled, AO disabled, cloud depth 8 steps, Sky water/wet reflections, shadow distance 48 blocks. Other installed defaults are preserved, including refraction/FXAA off and brightness 0.8/saturation 1.2. Air and Pro Max are unchanged. Art-style labels remain standard Minecraft ALL CAPS, now red for DARK FANTASY and light blue for MIYAZAKI.

### 0.9.14 reflection resolution

Performance → Water → Wet reflection resolution selects Half or Full. Half uses a genuinely half-width/half-height reflection target (quarter pixel count) with a separate full-resolution combination pass. Upscaling rejects depth-discontinuous samples and uses the full-resolution wet mask to keep reflections off dry objects. Rejected samples retain base shading. Air/Pro use Half; Pro Max uses Full. Reflection Off disables the reflection pass; the water snapshot combination pass remains when custom water is on. Water shaders and skybox are unchanged. Added pipeline/buffer overhead means FPS gains must be measured, not inferred from the quarter pixel count.

Player shadow is separate in Performance → Shadows. Included Pro settings use Player shadow On, Mob/entity shadows Off, Block entity shadows Off. Terrain shadows remain enabled. All presets keep the local player shadow on; Pro Max additionally retains mob and block-entity shadows.

### 0.9.15 source cleanup

Consolidates repeated deferred shaders into shared implementations, tidies shader whitespace and formats quality profiles into readable blocks. Required dimension entry points are retained. All 110 expanded shader entry points match the 0.9.14 baseline ignoring whitespace; rendering algorithms, presets and assets are unchanged. See docs/CODE-AUDIT-0.9.14.md for the audit and deferred optimization candidates.

