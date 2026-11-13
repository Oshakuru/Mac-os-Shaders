"""Check includes, preprocessing and DH stage interfaces without launching Minecraft."""
from pathlib import Path
import re, subprocess, zipfile
root=Path(__file__).resolve().parents[1]
pack=root
shaders=pack/'shaders'
def expand(path, options, chain=()):
    assert path not in chain, f'Include cycle: {path}'
    s=path.read_text()
    s=re.sub(r'^\s*#include\s+"([^"]+)"',lambda m:expand(shaders/m[1].lstrip('/'),options,chain+(path,)),s,flags=re.M)
    s=re.sub(r'^#version.*$', '',s, flags=re.M)
    for k,v in options.items():
        s=re.sub(r'^(#define '+k+r')\s+[^\n]+',lambda m:m[1]+' '+str(v),s,flags=re.M)
    return s
count=0
for dh in [False,True]:
 for style in [0,1,2]:
  for custom in [0,1]:
   opts={'VISUAL_STYLE':style,'CUSTOM_WATER':custom}
   for path in sorted(shaders.rglob('*.vsh')):
    if 'lib' in path.relative_to(shaders).parts:continue
    if not dh and path.name.startswith('dh_'):continue
    stages=[]
    for stage in [path,path.with_suffix('.fsh')]:
     src=('#define DISTANT_HORIZONS\n' if dh else '')+expand(stage,opts)
     p=subprocess.run(['/usr/bin/clang','-E','-P','-x','c','-nostdinc','-'],input=src,text=True,capture_output=True)
     assert p.returncode==0,(stage,p.stderr)
     s=p.stdout
     assert s.count('{')==s.count('}'),stage
     assert s.count('(')==s.count(')'),stage
     stages.append(s);count+=1
    if path.name.startswith('dh_'):
     vs,fs=stages
     assert 'mc_Entity' not in vs and 'texture2D(texture,' not in fs,path
     assert 'waterSceneReflection(' not in fs,path
     assert 'sampler2D shadowtex0' not in fs and 'texture2D(shadowtex0' not in fs,path
     varying=lambda s:dict((name,typ) for typ,name in re.findall(r'varying\s+(\w+)\s+(\w+)\s*;',s))
     assert varying(vs)==varying(fs),(path,varying(vs),varying(fs))
print(f'PASS: {count} shader stages preprocessed; DH interfaces and includes verified.')
print('This checks source structure, not GLSL compilation or Iris/DH rendering.')
