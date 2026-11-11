# Metal 0.9.14

- Genuine Half/Full wet-ground reflection resolution control. Half = half width/height, quarter shading/trace pixels.
- Separate reflection target with linear-depth metadata; full-resolution depth-aware upscaling and wet-mask combination before transparent water.
- Preserves the opaque water scene snapshot in target 4, now populated by deferred1.
- Air/Pro default Half; Pro Max Full. Manual changes show Custom.
- Binary toggles use Off/On, and Sky + Scene labels shorten to Sky +. Named styles and Half/Full keep descriptive values.
- Water and skybox rendering code unchanged. No bloom or temporal history added.

Check shoreline/object silhouettes, thin puddles, odd resolutions, water snapshots and FPS in Iris. Rejected/missing low-resolution samples retain base shading. Quarter reflection pixels does not imply four times the FPS.

- Separate Player shadow switch. Included Pro uses player-only entity shadows; terrain shadows remain enabled. Both block-entity and light-emitting block-entity shadows follow their shared switch.
