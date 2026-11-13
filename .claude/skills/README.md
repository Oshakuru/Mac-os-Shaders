# Project skills

Skills in this folder load only when Claude Code works in this repository. They are development aids and are not part of the built shaderpack.

- `ponytail*`: copied unmodified from https://github.com/DietrichGebert/ponytail at commit 96608e0 (version 5.3.3), MIT license, see `ponytail/LICENSE`. Only the skill instructions are included; the upstream hooks, scripts and plugins are not.
- Superpowers (`brainstorming`, `writing-plans`, `executing-plans`, `systematic-debugging`, `test-driven-development` and the other ten skill folders listed in the upstream repo): copied unmodified from https://github.com/obra/superpowers at commit 22f0b46 (version 7.0.2), MIT license, see `using-superpowers/LICENSE`. The upstream session-start hook and plugin manifests are not included.
- `graphify`: skill file and references copied unmodified from https://github.com/Graphify-Labs/graphify at commit 52cb282 (version 0.9.108), Apache-2.0, see `graphify/LICENSE` and `graphify/NOTICE`. The skill drives the separate `graphify` command-line tool, which is not included and must be installed on the machine (`uv tool install graphifyy`). No graphify hooks or CLAUDE.md registration are installed.
