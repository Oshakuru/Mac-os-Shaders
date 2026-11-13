# macOS Shaders 1.0

The pack formerly called Metal is now **macOS Shaders**, and version numbering restarts at 1.0. This release is Metal 1.2 under the new name. Next release: **1.1**.

- Renames the built pack to macOS-Shaders-v1.0.zip and its settings file to macOS-Shaders-v1.0.zip.txt.
- Updates the pack header, the cloud-style tooltip, README, changelog and versioning notes to the new name.
- Carries over the Metal 1.2 saved Custom settings byte for byte: Dark Fantasy, MakeUp water off, AO on with 8 samples and strength 0.32, sunbeam strength 0.22 with 8 steps, and water-reflection selection 2.

Shader programs, shared GLSL, textures and profile definitions are unchanged from Metal 1.2; internal identifiers and third-party modification notices still say Metal. No new in-game or FPS testing was performed. The logo is still the Metal-era vintage M pending new artwork. Earlier documents, including the [Metal 1.0 change report](docs/Metal-v1.0-changes.html) and the Metal settings files in config/, keep their original names.

macOS Shaders is not a native Apple Metal renderer and is not affiliated with or endorsed by Apple.

Build with tools/build.py and place macOS-Shaders-v1.0.zip beside macOS-Shaders-v1.0.zip.txt in shaderpacks. Cubic celestial and weather PNGs remain local-only inputs under the repository's existing distribution policy.
