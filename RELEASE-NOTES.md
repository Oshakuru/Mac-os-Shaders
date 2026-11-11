# Metal 0.9.15

- Shares the reflection pass, combination pass and fullscreen vertex implementation across their required Iris entry points.
- Normalizes shader whitespace and makes preset definitions readable continuation blocks.
- Updates validation tools to follow shared implementations and parse continued property lines.
- No rendering algorithm, asset, label, preset value or default-setting changes.
- Expanded shader source equivalence checked across all 110 entry points, ignoring whitespace only.

This cleanup reduces source duplication and maintenance risk. It does not claim an FPS gain. The 0.9.14 baseline is preserved in history.
