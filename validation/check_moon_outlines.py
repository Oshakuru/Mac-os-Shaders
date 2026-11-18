"""Preprocessor and numeric checks; does not replace GLSL/Iris or visual testing."""

import itertools
import math
import re
import subprocess  # nosec B404 - Clang preprocesses local shader source.
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SHADERS = ROOT / 'shaders'


def expand(path):
    return re.sub(r'^\s*#include\s+"([^"]+)"',
                  lambda m: expand(SHADERS / m[1].lstrip('/')),
                  path.read_text(), flags=re.MULTILINE)


programs = {d: expand(SHADERS / d / 'final.fsh') for d in ['', 'world-1', 'world1']}


def check(task):
    dimension, style, outlines, ao, beams, bloom, fxaa, shadows = task
    options = {'VISUAL_STYLE': style, 'MIYAZAKI_OUTLINES': outlines, 'MAX_AO': ao,
               'MAX_SUNBEAMS': beams, 'BLOOM': bloom, 'FXAA': fxaa, 'SHADOWS': shadows}
    text = programs[dimension]
    for key, value in options.items():
        text = re.sub(r'^(#define ' + key + r')\s+[^\n]+',
                      rf'\g<1> {value}', text, flags=re.MULTILINE)
    text = re.sub(r'^#version.*$', '', text, flags=re.MULTILINE)
    result = subprocess.run(['clang', '-E', '-P', '-x', 'c', '-nostdinc', '-'],  # nosec B603
                            input=text, text=True, capture_output=True, check=True).stdout
    uniforms = re.findall(r'^uniform\s+\w+\s+(\w+)\s*;', result, re.MULTILINE)
    assert len(uniforms) == len(set(uniforms)), task
    assert ('vec3 miyazakiOutlines(' in result) == bool(style == 2 and outlines), task
    for name in ['viewWidth', 'viewHeight', 'depthtex0', 'depthtex2', 'gbufferProjectionInverse', 'isEyeInWater']:
        if re.search(r'\b' + name + r'\b', result):
            assert name in uniforms, (task, name)
    for left, right in [('(', ')'), ('{', '}')]:
        assert result.count(left) == result.count(right), task


tasks = list(itertools.product(programs, range(3), *([range(2)] * 6)))
with ThreadPoolExecutor(max_workers=8) as pool:
    list(pool.map(check, tasks))

source = (SHADERS / 'lib/max_surface.glsl').read_text()
moon, day = map(float, re.search(r'mix\(([0-9.]+) \* MOON_CONTRAST, ([0-9.]+), daylight\)', source).groups())
# 1.9 night retune: moonlight scale 0.24 and night fill 0.040 (were 0.084 and 0.055).
assert math.isclose(moon, 0.24)
assert 'NIGHT_AMBIENT * 0.040' in source
assert day == 2.5
assert 'mix(1.2, 1.0, daylight)' in (SHADERS / 'lib/lighting.glsl').read_text()


def edge(center, neighbors):
    curvature = max((neighbors[0] + neighbors[1]) / center - 2,
                    (neighbors[2] + neighbors[3]) / center - 2)
    t = min(1.0, max(0.0, (curvature - 0.04) / 0.12))
    return t * t * (3 - 2 * t)


assert edge(10, [10, 10, 10, 10]) == 0
assert edge(10, [9, 11, 8, 12]) == 0
assert edge(10, [10, 30, 10, 10]) == 1
assert edge(30, [10, 30, 30, 30]) == 0
print(f'PASS: {len(tasks)} final-stage combinations, unique uniforms, outline gating, 1.9 moonlight values, and outline edge cases.')
