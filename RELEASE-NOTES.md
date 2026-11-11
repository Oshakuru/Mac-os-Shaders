# Metal 0.9.9

- Skip water and wet-ground scene traces whose contribution is below 1.5%; retain sky fallback.
- Reject invalid refined water reflection hits.
- Separate entity and block-entity shadow switches. Air/Pro disable both; Pro Max enables entity shadows; Plus enables both.
- Optional lightweight spatial edge smoothing, enabled on Pro Max/Plus. No temporal history, extra render pass or bloom.
- Neutral brightness, contrast, saturation and green-saturation controls in Style → Color grading. Color controls are independent of quality profiles.
- Performance controls continue to select Custom when changed.

Reflection resolution is deliberately deferred until the repaired water is confirmed stable in-game. This release does not claim half-resolution SSR or measured FPS gains. Visual effects still require in-game testing.
