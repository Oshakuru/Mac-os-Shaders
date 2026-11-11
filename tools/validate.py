#!/usr/bin/env python3
"""Portable source/metadata checks; does not replace Iris integration testing."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def main():
    count = 0
    for file in (ROOT / 'shaders').rglob('*'):
        if file.suffix not in {'.fsh', '.vsh', '.glsl'}:
            continue
        text = file.read_text()
        for include in re.findall(r'#include\s+"([^"]+)"', text):
            if not (ROOT / 'shaders' / include.lstrip('/')).exists():
                raise ValueError(f'{file.name}: missing include {include}')
        for name, arguments in re.findall(r'const\s+vec4\s+(\w+ClearColor)\s*=\s*vec4\(([^)]+)\)', text):
            components = arguments.split(',')
            if len(components) != 4:
                raise ValueError(f'{file.name}: Iris requires four components for {name}')
            for component in components:
                float(component.strip())
        active = re.sub(r'/\*[\s\S]*?\*/', '', text)
        for name, format_name in re.findall(r'const\s+int\s+(\w+Format)\s*=\s*(\w+)\s*;', active):
            if not format_name.isdigit() and not re.search(r'#define\s+' + re.escape(format_name) + r'\b', active):
                raise ValueError(f'{file.name}: {name} format is undeclared GLSL; use the documented block comment')
        count += 1
    # Iris only binds scene color targets 4+ during gbuffers rendering.
    water = (ROOT / 'shaders/lib/makeup_water.glsl').read_text()
    if re.search(r'uniform\s+sampler2D\s+(?:colortex[0-3]|gcolor|gdepth|gnormal|composite)\s*;', water):
        raise ValueError('Water cannot sample scene color targets 0-3 in Iris gbuffers; use target 4 or higher')
    for dimension in ['', 'world-1/', 'world1/']:
        snapshot = (ROOT / 'shaders' / (dimension + 'deferred1.fsh')).read_text()
        snapshot = re.sub(r'#include\s+"/([^"]+)"', lambda m: (ROOT / 'shaders' / m[1]).read_text(), snapshot)
        if 'DRAWBUFFERS:04' not in snapshot or 'gl_FragData[1] = vec4(color, 1.0)' not in snapshot:
            raise ValueError('Deferred must populate scene snapshot target 4 in every dimension')
    print(f'Validated includes and Iris-sensitive directives in {count} source files.')
    print('Cubic PNGs are intentionally external. Run tools/build.py to assemble the pack.')

if __name__ == '__main__':
    main()
