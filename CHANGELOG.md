# Development progression

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
