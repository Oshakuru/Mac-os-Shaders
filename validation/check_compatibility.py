"""Source checks only; does not replace Iris or in-game compilation/testing."""

import itertools
import re
import subprocess  # nosec B404 - Clang preprocesses local shader source.
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
SHADERS=ROOT/'shaders'
def expand(path,chain=()):
    assert path not in chain, path
    text=path.read_text()
    return re.sub(r'^\s*#include\s+"([^"]+)"',lambda m:expand(SHADERS/m[1].lstrip('/'),chain+(path,)),text,flags=re.MULTILINE)
def preprocess(text, version, options=None):
    for key, value in (options or {}).items():
        text=re.sub(r'^(#define '+key+r')\s+[^\n]+',rf'\g<1> {value}',text,flags=re.MULTILINE)
    text=re.sub(r'^#version.*$','',text,flags=re.MULTILINE)
    # Clang handles conditional directives; GLSL is not compiled here.
    result = subprocess.run(  # nosec B603 - fixed arguments, shader text goes to stdin.
        ['clang', '-E', '-P', '-x', 'c', '-nostdinc', '-'],
        input=f'#define MC_VERSION {version}\n#define IS_IRIS\n' + text,
        text=True,
        stdout=subprocess.PIPE,
        check=True,
    )
    return result.stdout


versions=[12001,12002,12003,12004,12101,12104,12111,260100,260200,260300]
for version in versions:
    s=preprocess(re.sub(r'^# (.*)$',r'// \1',(SHADERS/'block.properties').read_text(),flags=re.MULTILINE),version)
    ids=[x for x in s.splitlines() if x.startswith('block.10005=')]
    assert len(ids)==1
    assert ('minecraft:short_grass' in ids[0])==(version>=12003)
    assert ('minecraft:grass ' in ids[0])==(version<12003)
    assert ('minecraft:pale_oak_leaves' in s)==(version>=12104)
    assert ('minecraft:red_poplar_leaves' in s)==(version>=260300)
    assert ('minecraft:orange_poplar_leaves' in s)==(version>=260300)
    assert ('minecraft:yellow_poplar_leaves' in s)==(version>=260300)
    assert ('minecraft:red_shrub' in s)==(version>=260300)
    assert len([x for x in s.splitlines() if x.startswith('block.10002=')])==1
assert not list(SHADERS.rglob('dh_*'))
assert 'weatherProbe' not in (SHADERS/'lib/scene.vsh').read_text()
assert 'weatherIsRain' not in (SHADERS/'lib/interface.glsl').read_text()
weather=preprocess(expand(SHADERS/'gbuffers_weather.fsh'),12001,{'UNOBTRUSIVE_WEATHER':1})
assert 'weather.a *= 0.35' in weather
assert 'metalRainTexture' not in weather
programs=[p for p in SHADERS.rglob('*') if p.suffix in ['.fsh','.vsh'] and 'lib' not in p.relative_to(SHADERS).parts]
expanded={p:expand(p) for p in programs}
tasks=list(itertools.product(programs,[12001,12111,260100,260200,260300],[0,1,2],[0,1],[0,1]))
def check(task):
    p,version,style,custom,weather=task
    s=preprocess(expanded[p],version,{'VISUAL_STYLE':style,'CUSTOM_WATER':custom,'UNOBTRUSIVE_WEATHER':weather})
    for a,b in [('(',')'),('{','}')]:assert s.count(a)==s.count(b),(p,a)
with ThreadPoolExecutor(max_workers=8) as pool:list(pool.map(check,tasks))
print(f'PASS: mappings at {len(versions)} versions; {len(tasks)} program-stage preprocessing checks; weather fallback; no DH programs.')
