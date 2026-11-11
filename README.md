<p align="center"><img src="assets/branding/metal-vintage.png" width="240" alt="Metal vintage M logo"></p>

# Metal

Minecraft Java Edition visual pack developed around Apple Silicon, with selectable art styles, shadows, procedural water and rain puddles.

**Current revision: 0.9.7; in-game-tested baseline: 0.9.** Next revision: **0.9.8**. The earlier Metal 1.0 labels are preserved in the development history; they are not the current release number.

## Current features

- Default, Miyazaki and Dark Fantasy art styles.
- Air, Pro and Pro Max quality presets.
- SDV skybox clouds by default, with Fading Clouds and Vanilla available.
- MakeUp Ultra Fast-derived water waves, depth absorption, refraction and Sky + Scene reflections.
- Rain-driven puddles, wet-ground darkening and optional Sky + Scene reflections.
- Embedded cubic sun/moon support, including eight moon phases, when built with the separately supplied assets.
- Vertex sunbeam setup and sparse depth reconstruction optimizations.
- Organized settings under Performance, Style, Lighting, Atmosphere and Other.

Fresh Water and Fresh Rain were experimental and are removed from the current code. Rain/snow and particle sprites use the game's textures.

## Compatibility and testing

Tested by the developer on **Apple M1, Minecraft 1.21.11 and Iris 1.10.4**. OptiFine compatibility has not been verified. Metal is the product name; this is a GLSL/Iris pack, not a native Apple Metal renderer.

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

Place both generated files from `dist/` into Minecraft's `shaderpacks` folder and select **Metal-v0.9.7.zip** in Iris. The matching settings file carries Dark Fantasy and Sky + Scene puddle settings, with the SDV skybox clouds enabled.

For visible terrain/lava reflections select **Atmosphere → Puddles and Wet Ground → Wet ground reflections → Sky + Scene**. Sky mode reflects only the sky and can be subtle on dark rainy nights.

## Development history

Saved versions are imported as chronological source snapshots in Git history. These imports preserve old names and known failures; they do not pretend to be the original historical commit dates. See [CHANGELOG.md](CHANGELOG.md) and [history index](docs/HISTORY.md).

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

Cloud masks now have filtered continuous edges, smaller separated islands and four fixed texture reads instead of the previous 16. The skybox horizon fade is unchanged. Green terrain is selectively dimmed and desaturated in Miyazaki and Dark Fantasy; Default is unchanged. In-game appearance and FPS require comparison.

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
