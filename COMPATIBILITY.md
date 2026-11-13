# Minecraft compatibility — macOS Shaders 1.5

One standard shader ZIP, targeting Minecraft Java 1.20.1 through 1.21.11, plus 26.1, 26.2 and 26.3, with
an appropriate Iris/Sodium release for each Minecraft version. No DH support.
Use Iris 1.6.11 or newer; this is an API baseline, not a tested minimum build.
OptiFine and Oculus are not validated targets.

Version-aware mappings select grass below 1.20.3 and short_grass from 1.20.3,
and only reference pale oak leaves from 1.21.4. Other shared block IDs remain.
Unobtrusive Weather now attenuates the original weather texture's opacity to
35%, preserving Minecraft's own selection of rain versus snow and resource packs.
It no longer replaces weather textures or probes a 1.21.11-specific texture pixel.

Validation: archive integrity, includes, version-specific block mappings, and
preprocessing of all program stages across visual styles and weather/water options.
These checks do not compile shaders through Iris or launch Minecraft.
The range above is a target, not a claim of completed in-game verification.

In-game checks still needed on 1.20.1, 1.20.4, 1.21.1, 1.21.4 and 1.21.11:
all styles; sun/moon and clouds; rain/snow (including high altitude); foliage wind;
water, puddles and shadows; Nether and End. Use isolated test worlds.

Previous v1.4 source checks passed; v1.5 results are recorded below.

## Minecraft 26.x

Use the matching Iris/Sodium release for the exact Minecraft version. For 26.2
and 26.3 select Prefer OpenGL in Video Settings > Graphics API and restart.
Vulkan is not supported by this Iris shader pack. Do not interpret source
preprocessing as successful Iris compilation or in-game verification.

Iris formats 26.1, 26.2 and 26.3 as MC_VERSION 260100, 260200 and 260300.
Existing grass/pale-oak guards continue to select the newer block IDs. Poplar
leaves and red shrub are mapped only from 260300. No general shader-program
rewrite was justified by the API/source review; runtime regressions remain possible.

Verify rain/snow, water, shadows, sky, entities, translucency, foliage wind and
all dimensions in each version before advertising tested support.

References reviewed:
- https://raw.githubusercontent.com/IrisShaders/Iris/26.3/common/src/main/java/net/irisshaders/iris/gl/shader/StandardMacros.java
- https://raw.githubusercontent.com/IrisShaders/Iris/26.3/common/src/main/java/net/irisshaders/iris/compat/sodium/config/ShaderPackScreenPlaceholder.java
- https://www.minecraft.net/en-us/article/minecraft-java-edition-26-3

V1.5 source validation passed: mappings at 10 Minecraft version values and
6,960 program-stage preprocessing checks covering 1.20.1, 1.21.11, 26.1,
26.2 and 26.3 with all styles and weather/water options. Profile values passed.
The author reports successful gameplay on Minecraft 1.20.1 and 26.3.
Other listed versions remain unverified in-game. No independent Iris-driver
compilation tests were performed by the source-check script.

## User-tested release

On November 13, 2026, the author confirmed this shader works in Minecraft
1.20.1 and 26.3. This records successful use, not exhaustive feature testing.
