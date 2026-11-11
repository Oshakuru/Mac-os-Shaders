# Metal 0.9.11

- Optimizes wet-ground Sky reflections with flat normals; animated puddle normals remain only in Sky + Scene.
- Rejects low coverage and checks reflection visibility before reflection direction, sky color and highlight shading.
- Earlier distance fade for Sky mode; preserves puddle coverage and wet-ground darkening.
- Renames Sky (Fast) to Sky (Light), without claiming a fixed FPS gain.
- Keeps water, skybox and quality-preset selections unchanged.

This does not remove the mask/output bandwidth or introduce half-resolution reflections. Measure Off → Sky (Light) → Sky + Scene in a fixed in-game scene. The provided Pro settings retain Sky + Scene, so select Sky (Light) to test this optimization.
