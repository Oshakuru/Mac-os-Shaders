# Metal 0.9.5

- Replaces Photon-derived water with a MakeUp Ultra Fast 9.6 adaptation: three scrolling noise layers, .10 rational depth absorption, refraction, squared Fresnel reflection and sun/moon highlights.
- Adds an opaque scene snapshot in colortex2 for refraction/scene reflections without sampling the active water render target.
- Water defaults to Sky + Scene reflections; includes Sky-only and Off, plus refraction and absorption settings.
- Retains Metal rain rings, Fading Clouds, preset tones and Photon-derived rain puddles/wet-ground reflections.
- Keeps MakeUp's wave texture and LGPL-3.0 notice with modified source and author credit.

Adapted to Metal's GLSL 120 lighting and LDR pipeline; not pixel-identical to the source pack. No Distant Horizons/Voxy integration is added. New water/refraction/SSR and submerged/dimension behavior require Iris in-game verification. The scene snapshot adds buffer bandwidth and scene reflections add work; FPS must be measured.

- Default clouds now use Super Duper Vanilla v1.3.8's adapted skybox parallax renderer and original cloud map, with Metal's preset tones. Fading Clouds remain selectable as option 2; Vanilla is option 0. Matches the reference skybox mapping and horizon fade independently of terrain render distance. Compositing is adapted to Metal's LDR pipeline; the overall SDV bloom/tone-mapping pipeline is not included.
