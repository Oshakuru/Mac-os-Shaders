# Validation record

The source audit compiled 3,731 selected program configurations per original/cleanup build on the native Apple M1 GLSL 120 driver and compared 72 synthetic renders. Those checks did not exercise Iris's loader or patched OpenGL 4.1 code path.

Two assumptions were subsequently corrected using the live Iris error log:

1. `colortex1ClearColor` requires an explicit four-component constructor for Iris's metadata parser.
2. RGBA8 is not a GLSL built-in. Its format directive belongs in a block comment; test harnesses must not inject an RGBA8 definition that hides an undeclared identifier.

After both corrections, 150 program configurations per build passed direct-driver compilation without the injected constant. The user subsequently confirmed loading in Iris 1.10.4, visible puddle reflections in Sky + Scene mode and good performance.

The earlier approximately 215 FPS measurement describes a previous optimized baseline. No precise current-release FPS claim is made.

Current limits: coarse screen-space reflections miss offscreen/occluded objects; camera-biome wetness can mismatch at borders/altitude; water RGB absorption is approximated through alpha blending; sky reflections omit cloud/cubic sprite details. In-game tests remain necessary.
