# Metal 0.9.2

- Replaced Dark Fantasy blackletter with the requested script lettering and gray-to-white color progression, removing the old bold/italic formatting.
- Replaced Miyazaki full-width lettering with the requested small capitals and blue-to-pink color progression.
- Preserved exact supplied hex strings in assets/branding/preset-labels.json. Iris menu labels use the closest standard Minecraft colors; font coverage requires an in-game check.
- Rendering and the 0.9.1 weather/ripple settings are unchanged. The 0.9.1 effects still await in-game verification.

- Replaced Fading Clouds with original two-layer skybox clouds, independent of terrain render distance. Vanilla remains selectable. Matches the reference active skybox mode's angular horizon fade: clear sky fades from y=0.1 to y=0.2667; rain raises and softens that fade. Uses an original generated cloud mask, not reference-pack code or assets. No settings title was added.
