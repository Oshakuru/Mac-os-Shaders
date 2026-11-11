<p align="center"><img src="assets/branding/metal-vintage.png" width="240" alt="Metal vintage M logo"></p>

# Metal

Minecraft Java Edition visual pack developed around Apple Silicon, with selectable art styles, shadows, procedural water and rain puddles.

**Current tested baseline: 0.9.** Future revisions use **0.9.1 → 0.9.2 → 0.9.3**. The earlier Metal 1.0 labels are preserved in the development history; they are not the current release number.

## Current features

- Default, Cartoon Storybook and Dark Fantasy art styles.
- Air, Pro and Pro Max quality presets.
- Vanilla or Story Mode clouds.
- Photon-derived procedural water waves, depth coloring, sky reflections and sun highlights.
- Rain-driven puddles, wet-ground darkening and optional Sky + Scene reflections.
- Embedded cubic sun/moon support, including eight moon phases, when built with the separately supplied assets.
- Vertex sunbeam setup and sparse depth reconstruction optimizations.
- Organized settings under Performance, Style, Lighting, Atmosphere and Other.

Fresh Water and Fresh Rain were experimental and are removed from the current code. Rain/snow and particle sprites use the game's textures.

## Compatibility and testing

Tested by the developer on **Apple M1, Minecraft 1.21.11 and Iris 1.10.4**. OptiFine compatibility has not been verified. Metal is the product name; this is a GLSL/Iris pack, not a native Apple Metal renderer.

The developer confirmed that Story Mode clouds, both optimization switches, and Sky + Scene puddle reflections work with good performance. The approximately 215 FPS result belongs to an earlier optimized baseline, not a benchmark guarantee for the current pack. See [validation notes](docs/VALIDATION.md).

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

Place both generated files from `dist/` into Minecraft's `shaderpacks` folder and select **Metal-v0.9.zip** in Iris. The matching settings file carries the tested Dark Fantasy, Story Mode clouds and Sky + Scene puddle configuration.

For visible terrain/lava reflections select **Atmosphere → Puddles and Wet Ground → Wet ground reflections → Sky + Scene**. Sky mode reflects only the sky and can be subtle on dark rainy nights.

## Development history

Saved versions are imported as chronological source snapshots in Git history. These imports preserve old names and known failures; they do not pretend to be the original historical commit dates. See [CHANGELOG.md](CHANGELOG.md) and [history index](docs/HISTORY.md).

The progression runs from **M1-Light 0.5.5** through the 0.8 experiments, **Metal 1.0**, the cleanup and Iris fixes, and finally the tested **Metal 0.9** baseline. Earlier broken snapshots are retained for development reference.

## Contributing and licensing

The repository's existing GPLv3 `LICENSE` is retained. Third-party source and assets retain their own notices and terms; the root license does not relicense them. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the Photon and Story Mode adaptations and externally supplied cubic textures. Current third-party dependencies should be reviewed before repackaging or publishing through other distribution services.

Run `python3 tools/validate.py` before packaging. In-game testing remains necessary for Iris patching, buffer behavior, appearance and frame times.
