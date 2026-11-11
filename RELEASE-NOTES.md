# Metal 0.9.1

- Fading Clouds is the default cloud style; Vanilla remains selectable.
- Cartoon is renamed Miyazaki. Preset labels use the requested lettering and supported legacy colors; exact RGB requests are archived in assets/branding/preset-labels.json. Gothic glyph support depends on the game font.
- Embeds locally supplied Unobtrusive Weather rain/snow textures, without a resource pack or Particle Rain mod.
- Adds original shader-based expanding rain rings to outdoor reflective water, with toggle and strength control.
- Keeps the tested puddle/reflection system and both Iris fixes.

Static checks and packaging validation only. Rain/snow switching, new glyphs, ripple appearance and FPS still need in-game verification. The weather selector expects stock 1.21.11 weather textures; disable Unobtrusive weather if another pack replaces them. Splash/Particle Rain sprites are not embedded. Ripples use skylight to estimate rain exposure; this is not exact roof collision.
