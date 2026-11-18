#!/usr/bin/env python3
"""Assemble macOS Shaders from source, optionally using locally supplied cubic textures."""

import argparse
import runpy
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
# Fixed entry time so the same source always gives the same ZIP.
FIXED_TIME = (2026, 1, 1, 0, 0, 0)

def entry(name):
    info = zipfile.ZipInfo(name, FIXED_TIME)
    info.compress_type = zipfile.ZIP_DEFLATED
    info.external_attr = 0o644 << 16
    return info
CUBIC = {
    'shaders/textures/cubic/sun.png': 'assets/minecraft/textures/environment/sun.png',
    'shaders/textures/cubic/moon_phases.png': 'assets/minecraft/textures/environment/moon_phases.png',
}

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument('--cubic-pack', type=Path, help='Local Cubic Sun & Moon v1.8.5 ZIP')
    modes.add_argument('--without-cubic', action='store_true', help='Use the existing game celestial option')
    parser.add_argument('--output-dir', type=Path, default=ROOT / 'dist')
    args = parser.parse_args()
    # Refuse to package a pack that fails the source checks.
    for check in ['tools/validate.py', 'tools/check_profiles.py']:
        runpy.run_path(str(ROOT / check), run_name="__main__")
    version = (ROOT / 'VERSION').read_text().strip()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    output = args.output_dir / f'macOS-Shaders-v{version}.zip'
    extra = {}
    if args.cubic_pack:
        with zipfile.ZipFile(args.cubic_pack) as archive:
            for destination, source in CUBIC.items():
                extra[destination] = archive.read(source)
    with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED) as archive:
        for folder in ['shaders', 'licenses']:
            for file in sorted((ROOT / folder).rglob('*')):
                if not file.is_file() or file.name == '.DS_Store':
                    continue
                name = file.relative_to(ROOT).as_posix()
                if name in CUBIC:
                    continue
                data = file.read_bytes()
                if args.without_cubic and name == 'shaders/lib/settings.glsl':
                    data = data.replace(b'#define CUBIC_CELESTIALS 1', b'#define CUBIC_CELESTIALS 0')
                if name == 'shaders/shaders.properties' and args.without_cubic:
                    data = data.replace(b'CUBIC_CELESTIALS=1', b'CUBIC_CELESTIALS=0')
                archive.writestr(entry(name), data)
        for name, data in extra.items():
            archive.writestr(entry(name), data)
        for name in ['LICENSE', 'README.md', 'THIRD_PARTY_NOTICES.md', 'VERSION', 'VERSIONING.md', 'RELEASE-NOTES.md']:
            file = ROOT / name
            if file.exists():
                archive.writestr(entry(name), file.read_bytes())
        if archive.testzip():
            raise RuntimeError('ZIP integrity check failed')
    settings = (ROOT / f'config/macOS-Shaders-v{version}.zip.txt').read_text()
    if args.without_cubic:
        settings = settings.replace('CUBIC_CELESTIALS=1', 'CUBIC_CELESTIALS=0')
        if 'CUBIC_CELESTIALS=' not in settings:
            settings += '\nCUBIC_CELESTIALS=0\n'
    (args.output_dir / (output.name + '.txt')).write_text(settings)
    print(output)
    print('Source textures added locally.' if args.cubic_pack else 'Game celestial mode selected.')

if __name__ == '__main__':
    main()
