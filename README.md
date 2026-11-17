<p align="center"><img src="assets/branding/metal-vintage.png" width="240" alt="Vintage M logo from the Metal era"></p>

# macOS Shaders

Minecraft Java Edition visual pack developed around Apple Silicon, with selectable art styles, shadows, procedural water and rain puddles.

**Latest release: macOS Shaders 1.7** (GitHub prerelease, not a full stable release). [Download the v1.7 ZIP](https://github.com/Oshakuru/Mac-os-Shaders/releases/download/v1.7/macOS-Shaders-v1.7.zip) and [matching settings](https://github.com/Oshakuru/Mac-os-Shaders/releases/download/v1.7/macOS-Shaders-v1.7.zip.txt). The source here is at **1.9**; 1.8 and 1.9 are recorded as historical updates, not releases. Build them yourself with the steps below. The pack was formerly called Metal; macOS Shaders 1.0 is Metal 1.2 under the new name, 1.1 added bloom, 1.2 added reworked sunbeams, sun rays and lens flare, 1.3 replaces the water with a lighter design, 1.4 is a multiversion compatibility patch extending support to Minecraft 1.20.1–1.21.11, 1.5 is a multiversion compatibility patch adding Minecraft 26.1, 26.2 and 26.3, 1.6 gives each art style its own water tone and raises Miyazaki contrast by 20%, and 1.7 adds stronger moonlight and soft Miyazaki outlines. See [release notes](RELEASE-NOTES.md) and [compatibility notes](COMPATIBILITY.md).

Versions 1.8 and 1.9 are source updates recorded in the [development history](docs/HISTORY.md), not releases: 1.8 brings SDV-style moonlit nights, a Miyazaki Skybox cloud style and rain ripples near the player and on puddles; 1.9 sets the Pro preset to the author's in-game settings, turns wet ground reflections off by default for performance, and finishes the rename from Metal to macOS Shaders.

## Current features

- Vanilla, Miyazaki and Dark Fantasy art styles.
- Air, Pro and Pro Max quality presets.
- SDV skybox clouds by default, with Miyazaki Skybox (pixel-art panorama), Fading Clouds and Vanilla available.
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
| 1.9 | Pro preset and polish | Pro preset set to the author's in-game settings; wet ground reflections off by default; Metal-era code renamed to macOS Shaders; builder runs the checks and writes repeatable ZIPs | Tested in game; not released |
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

## To do

- Vanilla-style rework of lava and the nether portal.
- Distant Horizons compatibility.

## Contributing and licensing

The repository's existing GPLv3 `LICENSE` is retained. Third-party source and assets retain their own notices and terms; the root license does not relicense them. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the Photon and Story Mode adaptations and externally supplied cubic textures. Current third-party dependencies should be reviewed before repackaging or publishing through other distribution services.

Run `python3 tools/validate.py` before packaging. In-game testing remains necessary for Iris patching, buffer behavior, appearance and frame times.

## Multiversion compatibility patches 1.4 and 1.5

Patch 1.4 adds Minecraft Java 1.20.1–1.21.11 compatibility; patch 1.5 extends it to 26.1, 26.2 and 26.3 with Iris on OpenGL. Later versions retain these compatibility mappings. See [compatibility notes](COMPATIBILITY.md) for requirements, changes and testing status. This build does not include Distant Horizons support.
