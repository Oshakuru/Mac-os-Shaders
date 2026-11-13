# Development progression

## macOS Shaders 1.2 — in development

- Reworked sunbeams (contrast, wider angle, denser air, strength up to 0.40) and added screen-space sun rays through canopies.
- Pro preset and shader defaults now match the author's saved Custom settings; Dark Fantasy is the default style and keeps its original colours.
- Cheaper shadow-space matrix maths in sunbeams and shadows.

## macOS Shaders 1.1

- Added optional bloom (tight halo around bright light sources), off in Air.

## macOS Shaders 1.0

- Renamed the pack from Metal to macOS Shaders and restarted version numbering at 1.0.
- Build output is now `macOS-Shaders-v1.0.zip` with `config/macOS-Shaders-v1.0.zip.txt`, a byte-for-byte copy of the Metal 1.2 saved settings.
- Shader programs, profiles, textures and option defaults unchanged from Metal 1.2. Internal GLSL identifiers keep their `metal` prefix.

Entries below use the Metal name and its version numbers.

## 1.2

- Imported the author-supplied pack's menu labels, compressed public textures, SDV metadata and notice, and exact saved Custom settings.
- Renamed Default art style to Vanilla. Shader code and profiles unchanged.
- Corrected release metadata to 1.2; next release is 1.3.
- Third-party local-only textures remain excluded.


## 1.0 — official release

- Author-designated promotion of audited 0.9.15 to official Metal 1.0. Rendering, assets and preset values unchanged.

## 0.9.15

- Consolidated repeated deferred implementations and tidied source formatting without rendering changes.

## 0.9.14

- Added true half/full wet-reflection rendering and depth-aware reconstruction, Off/On toggle labels and Sky + naming.

## 0.9.13

- Refreshed Pro from the latest user Custom configuration. Set DARK FANTASY red and MIYAZAKI light blue.

## 0.9.12

- Added low/medium/high impact colors to setting labels; removed all formatting from art-style titles. Rendering unchanged.

## 0.9.11

- Optimized wet-ground Sky shading with flat normals, early visibility gating and earlier distance fading. Water/skybox unchanged.

## 0.9.10

- Consolidated into three presets: former Pro → Air, saved Custom → Pro, former Plus → Pro Max. FXAA off throughout.

## 0.9.9

- Reflection visibility/rejection improvements, separate shadow-caster controls, optional edge smoothing and basic grading. No bloom. Reflection-resolution restructuring remains deferred.

## 0.9.8

- Added Pro Max Plus and rebalanced all four quality profiles with a real shadows-off path, cloud-layer control, and scalable AO/sunbeam/water-reflection sampling.
- Air/Pro share the requested single cloud layer and disable reflections, AO and sunbeams.

## 0.9.7

- Added vertex-only foliage wind with distance culling, anchored plant bases and matching shadow movement.

## 0.9.6

- Changed art-preset labels to standard Minecraft lettering in ALL CAPS.

- Fixed water sampling the block atlas by moving its scene snapshot to an Iris-supported gbuffers target (colortex4). Skybox unchanged.

## 0.9.5

- Replaced water with a credited MakeUp Ultra Fast 9.6 adaptation and added a dedicated opaque refraction/reflection snapshot. Ground puddles remain unchanged.

## 0.9.4

- Restored Fading Clouds, added a broader sky-background treatment with existing preset tones, and corrected grass-card lighting orientation.
- Removed the unsuccessful general green albedo adjustment.

## 0.9.3

- Smoothed and separated skybox clouds; reduced cloud sampling cost.
- Restrained bright green terrain in Miyazaki and Dark Fantasy.

## 0.9.2

- Updated Dark Fantasy and Miyazaki lettering and label color approximations from the supplied designs. Removed Dark Fantasy bold/italic formatting.
- Rendering unchanged.

## 0.9.1

- Renamed Cartoon to Miyazaki, added styled preset labels, and made Fading Clouds the default.
- Integrated locally supplied Unobtrusive Weather rain/snow and original shader-based water rain ripples.
- See RELEASE-NOTES.md for test status and font/texture limitations.

## 0.9 — current baseline

- Relabeled the tested Metal cleanup + Iris Fix 2 build as 0.9.
- Preserved the successful optimization switches, art styles, Story Mode clouds, Photon water and Sky + Scene puddle settings.
- Established patch increments: next 0.9.1, then 0.9.2.
- User confirmed in-game loading, visible scene reflections and good performance.

## Former Metal 1.0 labels

- Adopted the Metal name and vintage Macintosh-inspired capital M identity.
- Refactored shared sky, depth, daylight and water logic; reduced unnecessary reflection work.
- Fixed Iris clear-color parsing with four explicit components.
- Fixed the undeclared RGBA8 error by placing the format directive in Iris's documented block-comment form.
- Native-driver tests alone missed both Iris-specific integration assumptions; validation now checks them explicitly.

## M1-Light 0.8 development

- Selected 0.8 as the visual/performance baseline; 0.8.1 was reported 20–30 FPS slower.
- Added organized settings menus and separate art styles.
- Moved sunbeam setup to vertices and added sparse depth reconstruction.
- Added selectable Story Mode clouds.
- Developed Cartoon Storybook using Ni no Kuni and animation references; darkened Dark Fantasy.
- Integrated cubic celestial support.
- Tried Fresh Water/Fresh Rain, then removed them.
- Adapted Photon water, puddles and optional screen-space ground reflections.

## M1-Light 0.5.5–0.7

Available early development source snapshots are preserved in Git history. Their original identifiers are retained rather than assigning invented Metal release numbers.

- Replaced Fading Clouds with original two-layer skybox clouds, independent of terrain render distance. Vanilla remains selectable. Matches the reference active skybox mode's angular horizon fade: clear sky fades from y=0.1 to y=0.2667; rain raises and softens that fade. Uses an original generated cloud mask, not reference-pack code or assets. No settings title was added.

- Default clouds now use Super Duper Vanilla v1.3.8's adapted skybox parallax renderer and original cloud map, with Metal's preset tones. Fading Clouds remain selectable as option 2; Vanilla is option 0. Matches the reference skybox mapping and horizon fade independently of terrain render distance. Compositing is adapted to Metal's LDR pipeline; the overall SDV bloom/tone-mapping pipeline is not included.
