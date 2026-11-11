# Metal 0.9.4

- Restores Fading Clouds; removes the experimental skybox cloud renderer and mask.
- Broad sun/moon diffusion and lower-sky falloff inspired by the reference sky background, using original Metal code and existing preset palettes.
- Grass and fern cards use upward-facing lighting in Miyazaki/Dark Fantasy, matching ground-facing direct light and ambient response while retaining geometric shadow receiver normals.
- Removes the broad 0.9.3 green albedo adjustment; retains the removal of Miyazaki's yellow-green lift.
- Preserves water, rain/ripples, reflections and labels.

This does not copy or redistribute Super Duper Vanilla source/assets. In-game cloud appearance, vegetation matching and FPS need testing. The restored geometry clouds retain their prior geometry-limited range.
