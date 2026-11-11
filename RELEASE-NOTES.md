# Metal 0.9.3

- Smooth filtered cloud edges and smaller, separated cloud islands.
- Removed mask morphing that mixed cloud shapes; composited a subtle upper layer.
- Reduced cloud mask reads from 16 to four per eligible sky pixel, removing the depth quality setting.
- Preserved the skybox horizon reach, weather fade and preset-specific colors.
- Reduced green terrain brightness/saturation in Miyazaki and Dark Fantasy before lighting, and removed Miyazaki's extra yellow-green lift. Default and non-green surfaces retain their existing response.
- Carries forward weather, water ripples, labels and working reflection settings.

Needs in-game visual and performance verification. Shader-driver checks do not validate Iris rendering appearance.
