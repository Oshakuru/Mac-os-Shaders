# Project skills

Skills in this folder load only when Claude Code works in this repository. They are development aids and are not part of the built shaderpack.

- `ponytail*`: copied unmodified from https://github.com/DietrichGebert/ponytail at commit 96608e0 (version 5.3.3), MIT license, see `ponytail/LICENSE`. Only the skill instructions are included; the upstream hooks, scripts and plugins are not.
- `graphify`: skill file and references copied unmodified from https://github.com/Graphify-Labs/graphify at commit 52cb282 (version 0.9.108), Apache-2.0, see `graphify/LICENSE` and `graphify/NOTICE`. The skill drives the separate `graphify` command-line tool, which is not included and must be installed on the machine (`uv tool install graphifyy`). No graphify hooks or CLAUDE.md registration are installed.
- `shader-programming`: copied unmodified from https://github.com/gamedev-skills/awesome-gamedev-agent-skills (`skills/disciplines/shader-programming`) at commit c6ca6c4, Apache-2.0, see `shader-programming/LICENSE` and `shader-programming/NOTICE`. Its examples target GLSL `#version 330`; this pack is GLSL 120 on Iris, so treat its syntax as reference only.
