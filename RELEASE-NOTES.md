# Metal 0.9.6

- Fixes the block-atlas mosaic in water refraction/reflections by moving the opaque scene snapshot from colortex2 to colortex4, supported during Iris gbuffers rendering.
- Deferred draws to targets 0 and 4 in all dimensions; water reads only the supported snapshot target.
- Adds validation for unsupported low-numbered scene samplers in water and the matching snapshot output.
- SDV skybox source, texture, presets, water waves and ground puddles remain unchanged.

The 0.9.5 compiler checks missed a pipeline binding requirement. Verify the repaired water in Iris; driver compilation alone does not confirm in-game output.
