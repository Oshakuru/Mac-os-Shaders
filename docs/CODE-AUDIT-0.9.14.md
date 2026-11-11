# Metal 0.9.14 code and asset audit

Audited 2026-11-10. The behavior-preserving cleanup is delivered as **0.9.15**. This report distinguishes confirmed source facts, tested cleanup, and optimizations that still require implementation/measurement.

## Baseline and scope

- Inspected the installed `Metal-v0.9.14.zip`; SHA-256: `41ba7cad5ddc65d0293e4f577a9228ce431da54add8ae69bc5dbc1ebc1395e2b`.
- All inspected shader/config/language text matched the working source before cleanup: no source differences.
- Baseline: 152 shader-directory files, 110 program entry points, 2,545 shader-source lines including repeated implementations, seven runtime PNGs in the playable archive.
- Reviewed include reachability, duplicate contents, material IDs, settings/profile coverage, pass routing, framebuffer usage, shader math, texture-channel usage, dimension overrides and packaging scripts.
- Historical ZIPs, reference packs, logo concepts and unrelated Downloads files are not runtime dependencies and were not deleted.

## Safe cleanup completed in 0.9.15

| Change | Why | Runtime effect |
|---|---|---|
| Shared wet-reflection implementation | Three identical copies of `deferred.fsh` | Same expanded shader |
| Shared combination implementation | Three identical copies of `deferred1.fsh` | Same expanded shader |
| Shared fullscreen vertex implementation | Six identical deferred vertex shaders | Same expanded shader |
| Consistent whitespace/directive indentation | Remove formatting noise | None |
| Readable multiline preset blocks | Previously 52 settings per single long line | Same parsed values |
| Validator follows shared includes and continued property lines | Previous checks assumed copied files and one-line profiles | Better maintenance checks |

The new shared files are `shaders/lib/wet_reflection_pass.glsl`, `shaders/lib/wet_combine_pass.glsl` and `shaders/lib/deferred_vertex.glsl`. Small root/dimension wrappers remain because Iris selects programs by their paths.

Shader text decreased from **99,733 to 80,566 bytes**, a **19,167-byte reduction (19.2%)**. This is source cleanup, not an FPS improvement: expanded GPU programs remain equivalent.

## Asset and dead-code findings

**No unreachable shared shader library, stale option label, duplicate language key, or unused runtime texture was found.** Optional modes count as live uses: Fading Clouds, custom weather and custom celestial assets are still selectable. Include reachability alone does not prove that every conditional branch executes in every preset.

The inventory's include guard is not a user option. Actual option declarations all have labels and references. The 39 Performance controls are covered by all three quality profiles.

| Runtime asset | Dimensions | Archive source bytes | Finding |
|---|---:|---:|---|
| MakeUp wave map | 256×256 | 68,594 | R/G used; required for custom waves |
| SDV cloud map | 256×256 | 28,678 | R/G used; required for skybox clouds |
| Photon puddle noise | 512×512 | 758,477 | Only alpha is sampled; unused RGB payload is a packaging opportunity |
| Cubic sun | 2048×2048 | 1,264,193 | Live but high resolution |
| Cubic moon atlas | 8192×4092 | 3,540,558 | Live; largest texture-memory candidate |
| Unobtrusive rain | 64×256 | 1,524 | Live when custom weather enabled |
| Unobtrusive snow | 64×256 | 177 | Live when custom weather enabled |

A trial in-memory alpha-preserving LA encoding of puddle noise is **156,857 bytes**, roughly **602 KB smaller** than the source PNG. This is a candidate only; no texture was modified. Validate decoding/filtering before shipping. Smaller PNGs do not automatically reduce GPU memory or FPS cost, since the engine may still upload RGBA textures.

Assuming RGBA8 upload, the sun and moon alone require approximately **16 MiB + 127.875 MiB** before mipmaps. These are format-based estimates, not measured allocations. A compact celestial option could substantially reduce resident texture memory. Downsample moon phases individually to avoid atlas bleed, and update the hard-coded half-texel inset in `cubic_celestials.glsl`. Texture quality and local-only asset licensing/build behavior must remain correct. There is no evidence that reducing these textures alone will increase FPS in the benchmark scene.

The Nether/End `deferred` reflection programs are always disabled by current properties. Their small wrappers are retained rather than deleting program entry points. Their large duplicate bodies have already been consolidated. `deferred1` remains necessary there while custom water needs its scene snapshot.

## Remaining optimization candidates, ranked

### 1. Fuse the Full-resolution reflection route — high potential, requires image tests

Currently Full still renders reflection color/depth into RGBA16F target 5 and then reconstructs/composes at full resolution in `deferred1`. That extra intermediate is useful for Half, but the Full mode could use a direct reflection-and-snapshot pass without an intermediate/reconstruction pass. This could reduce bandwidth and pass overhead for Full/Pro Max. Keep the working Half path as the control.

This is not implemented in 0.9.15. Need matched full-mode images, water snapshot validation, transparent-object checks, and measured frame times.

### 2. Remove the scene-copy dependency for simple water modes — high potential, architectural change

`makeup_water.glsl` always samples target 4 and returns alpha 1, including Sky reflections with refraction off. The current Pro preset uses precisely that combination. An ordinary alpha-blended formulation could combine absorption and sky reflection without copying the opaque background. The intended blend can be expressed algebraically, but fog, overlapping translucency and underwater transitions must be checked. Air also needs separate treatment because refraction is on there.

Do not remove target 4 from the current shader without changing composition: that would reproduce the broken-water problem. Scene reflections/refraction still require a snapshot in their existing implementation.

### 3. Specialize non-Overworld water snapshot passes — small to medium opportunity

Nether/End have no wet receiver-mask output, and their reflection pass is disabled. Their shared `deferred1` nevertheless includes the wet-mask read/branch while copying the scene for water. A dimension-specific define could compile out the wet reconstruction code there while retaining the water snapshot. The benefit is scene-dependent and smaller than removing a whole pass.

### 4. Compute invariant sky data once per frame/vertex — modest opportunity

`sdv_clouds.glsl` computes the same time-dependent fade sine and sun-height day/twilight values for sky fragments. These can be supplied as uniforms or constant-across-primitive varyings. Keep actual view-ray normalization and parallax sampling per fragment. Cloud texture fetches remain the larger cost; do not promise a large gain from this arithmetic cleanup.

### 5. Reuse existing transformations and normalization — modest opportunity

Terrain with wind computes player-space position before displacement, transforms back to view, and later reconstructs player-space position. Water also transforms its normal to view space twice in the scene-reflection branch. Reusing local results could simplify source and reduce redundant operations where the compiler does not already remove them. Must compare generated code/timing before claiming savings.

### 6. Move derivative-dependent ripple width outside divergent branches — correctness hardening

`rain_ripples.glsl` uses `fwidth` from a helper called conditionally on light level, material orientation and weather. Derivatives inside non-uniform control flow can be unreliable at branch boundaries. Compute a valid derivative footprint before divergence, then pass it into the optional ring calculation. This is a potential stability issue, not an observed screenshot defect or guaranteed speedup.

### 7. Share reflection receiver/contribution helpers — maintenance improvement

The low-resolution reflection pass and full-resolution combination pass both compute receiver normals, Fresnel and distance fade. They deliberately need evaluations at different pixel grids; removing one evaluation blindly would change the result. Extract matching math into a helper to prevent future drift, preserving the two evaluations where needed. The two SSR tracers also differ in depth source, step distribution and refinement, so they should not be merged blindly.

## Additional robustness findings

- Weather classification probes a fixed blue pixel in the stock 1.21.11 rain texture. It is efficient but brittle with weather resource packs. Existing disable guidance is appropriate; an explicit rain/snow override would be more robust than guessing arbitrary replacement textures.
- Underwater custom water returns the supplied lit color early. That deserves an underwater visual test; above-water confirmation does not validate the transition.
- Strength sliders generally scale appearance without removing effect cost. Existing impact colors should not be interpreted as measured per-option FPS results.
- The public build correctly disables unavailable cubic/weather replacements in both shader defaults and profiles when external inputs are absent. Manual re-enabling of unavailable assets can still fail; consider making those options unavailable in asset-free builds.
- Quality validation contains historical assertions about the chosen Pro configuration (wind on, refraction off). Prefer explicit preset specification data and generic coverage checks as future presets evolve.
- The generated shader ZIP's README references repository branding/docs not all packaged by the builder. This does not affect rendering, but release documentation should distinguish repository-relative links from archive-local content.
- Large historical sections in the main README retain obsolete preset descriptions. Keep one current feature table and move release-by-release detail to the changelog.

## What should not be removed or “optimized” blindly

- Target 1 mask writes on non-ground geometry prevent reflected terrain behind dry objects from leaking onto them.
- Target 4 is the supported gbuffers scene sampler used by water; targets 0–3 cannot replace it there.
- Full-resolution wet coverage and depth rejection protect edges in the Half path.
- Vertex-entry wrappers, third-party attribution/license files, and alternate cloud/weather/celestial paths are intentional.
- Uniform declarations and helper functions unused in a particular compiled configuration are normally eliminated by the compiler; deleting them from shared source is not automatically an optimization.
- No native Apple Metal API rewrite is implied. Metal is a GLSL/Iris pack using Minecraft's OpenGL path; this audit concerns its shader and pipeline costs.

## Verification and limits

- Baseline include/metadata validation and all three profiles/39 Performance controls passed.
- **1,408 native compile/link checks** passed: 128 seeded mixed manual configurations across 11 program pairs (seed 914). This samples combinations; it is not an exhaustive Cartesian product.
- **110 expanded entry points** remained source-equivalent after cleanup, ignoring whitespace only, including retained metadata comments.
- All parsed profile setting maps remained identical before/after formatting.
- Final native profile checks and archive asset/default equivalence are recorded alongside the delivered cleanup.
- No in-game FPS gain is claimed. User baseline evidence remains 183 FPS Half versus 163 FPS Full, approximately 0.67 ms/frame difference in that reported comparison.

Recommended next implementation order: retain this clean baseline, investigate the fused Full path, then investigate alpha-blended simple water. Make changes one at a time and compare identical scenes and frame times.

Final cleanup verification: 495 profile/style/program checks passed. All 12 runtime texture/metadata files and the language file are byte-identical to the installed baseline. Both full local and asset-free fallback builds passed.
