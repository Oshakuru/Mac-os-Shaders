# macOS Shaders versioning

Current update: **macOS Shaders 1.6** (in-game tested; published as a GitHub prerelease, not a full stable release). **1.0** is Metal 1.2 under the new name, with no rendering changes; **1.1** added bloom; **1.2** added the sunbeam rework, screen-space sun rays, lens flare and sun size; **1.3** replaces the water; **1.4** is a multiversion compatibility patch that adds Minecraft 1.20.1–1.21.11 support and the texture-free Unobtrusive Weather; **1.5** is a multiversion compatibility patch that adds Minecraft 26.1, 26.2 and 26.3; **1.6** adds per-style water tones and 20% more Miyazaki contrast.

The pack was called Metal through Metal 1.2. The author renamed it to macOS Shaders and restarted numbering at 1.0; macOS Shaders 1.0 follows Metal 1.2 and is unrelated to the earlier Metal 1.0.

Versions 1.4 and 1.5 retain their existing numbers and tags; both are multiversion compatibility patches. Version 1.6 retains that compatibility and adds the water/contrast changes.

Numbering rule, set by the author:

- **Each new feature adds 0.1** to the version: 1.1, 1.2, 1.3, and so on.
- **A full stable release takes the next whole number**: 2.0, 3.0, and so on. Whole numbers mark stable releases; the .1 steps in between are feature builds.

Bump `VERSION` and rename `config/macOS-Shaders-v<version>.zip.txt` together; the builder needs both to match. Update the release notes, changelog and README in the same change. Preserve the Metal 0.9.x, 1.0 and 1.2 development history and their `config/Metal-v*.zip.txt` settings files.
