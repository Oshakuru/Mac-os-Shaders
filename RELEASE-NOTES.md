# macOS Shaders 1.2 — in development

Not yet released; these notes track work in progress. Builds on 1.1 (bloom), which builds on 1.0 (Metal 1.2 under the new name).

## 1.2 — sunbeams and sun rays

- Reworks sunbeams: shadowed air is dimmed as well as sunlit air brightened, the visible angle is wider, the air is denser, and strength now goes up to 0.40.
- Adds screen-space sun rays, so light streams through gaps in tree canopies towards the camera. Uses the sunbeam options.
- Dark Fantasy palette: olive shadows instead of blue, and a golden-olive daytime sky and sun glow. Night colours unchanged.
- Cheaper shadow-space maths for sunbeams and shadows; the image is unchanged.

## 1.1 — bloom

- Adds optional bloom: a tight glow around bright light sources such as torches, candles, lava, portals and the sun. Options: Bloom, Bloom strength, Bloom threshold. Off in Air, on in Pro and Pro Max.

Not yet compiled or tested in Iris; visuals and frame times still need in-game checks. The Custom settings file carries over from Metal 1.2 unchanged.

macOS Shaders is not a native Apple Metal renderer and is not affiliated with or endorsed by Apple.

Build with tools/build.py and place macOS-Shaders-v1.2.zip beside macOS-Shaders-v1.2.zip.txt in shaderpacks. Cubic celestial and weather PNGs remain local-only inputs under the repository's existing distribution policy.
