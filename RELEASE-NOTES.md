# macOS Shaders 1.6

- Water tone now follows the art style: muddy and slightly murkier in Dark Fantasy,
  light blue and slightly clearer in Miyazaki. Vanilla keeps the 1.5 teal.
- Miyazaki carries 20% more contrast, built into the style; the Contrast slider still applies on top.
- Retains the multiversion compatibility patches from 1.4 and 1.5.
- No menu, preset or shadow-algorithm changes.
- Includes the author-supplied 1.6 settings; presets are unchanged.

The author has tried 1.6 in game and approved the new water tones, while reporting
foliage-shadow flicker. Comprehensive style/lighting checks and controlled FPS
benchmarks remain outstanding. The experimental static-foliage-shadow variant
was rejected after a reported performance drop and is not included in this baseline.

# macOS Shaders 1.5 — multiversion compatibility patch

- Extends the single-ZIP compatibility target to Minecraft 26.1, 26.2 and 26.3.
- Adds 26.3-only poplar leaf mappings (exclude puddles, retain foliage wind).
- Adds the red shrub to the existing small-plant wind/material mapping on 26.3.
- Retains mappings and weather fallback for Minecraft 1.20.1–1.21.11.
- No DH integration. Iris uses OpenGL; Vulkan is not a supported target.

Tested in game by the developer on Minecraft 1.20.1 and 26.3; versions in between
are covered by source checks only. See COMPATIBILITY.md.

# macOS Shaders 1.4 — multiversion compatibility patch

- Adds version-aware block mappings for Minecraft 1.20.1–1.21.11.
- Makes Unobtrusive Weather fade the game rain/snow textures rather than replace them.
