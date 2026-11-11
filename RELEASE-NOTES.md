# Metal 1.2

Imported from the author's supplied Metal-v1.2.zip and matching settings file. Next release: **1.3**.

- Adds impact-colored quality values and renames the Default art style to Vanilla.
- Imports compressed MakeUp water, Photon puddle-noise and SDV cloud textures, plus updated SDV metadata and notice.
- Preserves the supplied Custom settings exactly: Dark Fantasy, MakeUp water off, AO on with 8 samples and strength 0.32, sunbeam strength 0.22 with 8 steps, and water-reflection selection 2.
- Corrects stale internal 1.0 release identity in the repository to 1.2.

Shader programs, shared GLSL and profile definitions match the previous repository source byte for byte. ZIP integrity was checked; no new in-game or FPS testing was performed. The earlier [change report](docs/Metal-v1.0-changes.html) retains its original wording; the supplied settings supersede its Vanilla-settings description.

Build with tools/build.py and place Metal-v1.2.zip beside Metal-v1.2.zip.txt in shaderpacks. Cubic celestial and weather PNGs remain local-only inputs under the repository's existing distribution policy, so the supplied full ZIP is not published here.
