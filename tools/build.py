#!/usr/bin/env python3
"""Assemble Metal from source, optionally using locally supplied cubic textures."""
import argparse
from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parents[1]
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
    version = (ROOT / 'VERSION').read_text().strip()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    output = args.output_dir / f'Metal-v{version}.zip'
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
                archive.writestr(name, data)
        for name, data in extra.items():
            archive.writestr(name, data)
        for name in ['LICENSE', 'README.md', 'THIRD_PARTY_NOTICES.md', 'VERSION', 'VERSIONING.md', 'RELEASE-NOTES.md']:
            file = ROOT / name
            if file.exists():
                archive.write(file, name)
        if archive.testzip():
            raise RuntimeError('ZIP integrity check failed')
    settings = (ROOT / 'config/Metal-v0.9.zip.txt').read_text()
    if args.without_cubic:
        settings = settings.replace('CUBIC_CELESTIALS=1', 'CUBIC_CELESTIALS=0')
        if 'CUBIC_CELESTIALS=' not in settings:
            settings += '\nCUBIC_CELESTIALS=0\n'
    (args.output_dir / (output.name + '.txt')).write_text(settings)
    print(output)
    print('Source textures added locally.' if args.cubic_pack else 'Game celestial mode selected.')

if __name__ == '__main__':
    main()
