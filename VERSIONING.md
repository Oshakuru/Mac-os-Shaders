# macOS Shaders versioning

In development: **macOS Shaders 1.1**, not yet released. **macOS Shaders 1.0** is Metal 1.2 under the new name, with no rendering changes. Last released version: **Metal 1.2**. After 1.1 ships, the next changed release is **1.2**.

The pack was called Metal through Metal 1.2. The author renamed it to macOS Shaders and restarted numbering at 1.0; macOS Shaders 1.0 follows Metal 1.2 and is unrelated to the earlier Metal 1.0.

Numbering rule, set by the author:

- **Each new feature adds 0.1** to the version: 1.1, 1.2, 1.3, and so on.
- **A full stable release takes the next whole number**: 2.0, 3.0, and so on. Whole numbers mark stable releases; the .1 steps in between are feature builds.

Bump `VERSION` and rename `config/macOS-Shaders-v<version>.zip.txt` together; the builder needs both to match. Update the release notes, changelog and README in the same change. Preserve the Metal 0.9.x, 1.0 and 1.2 development history and their `config/Metal-v*.zip.txt` settings files.
