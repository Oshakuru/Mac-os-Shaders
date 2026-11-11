# Metal 0.9.7

- Adds lightweight Overworld wind for leaves, grass, ferns and crops, enabled at subtle strength.
- Two sine evaluations for moving vertices, with squared-distance fade from 24 to 48 blocks and early rejection outside that range.
- Anchors plant roots and matches tall-plant halves at their shared seam; leaves use a smaller displacement.
- Uses the same deformation in the terrain and shadow vertex shaders. No new textures, buffers, passes or fragment-shader wind work.
- Performance menu has wind on/off and strength. Off compiles out the path.
- Preserves the SDV skybox, MakeUp water binding fix, rain effects and standard-font art-preset labels.

In-game motion, shadow alignment, crop shapes, and FPS comparison still need testing. No quantified performance claim is made.
