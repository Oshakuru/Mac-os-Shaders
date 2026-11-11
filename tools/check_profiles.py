"""Validate menu coverage, legal profile values and Custom matching behavior."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def check():
    text = (ROOT / 'shaders/shaders.properties').read_text()
    text = re.sub(r'\\\r?\n[ \t]*', ' ', text)
    settings = (ROOT / 'shaders/lib/settings.glsl').read_text()
    allowed = {}
    for line in settings.splitlines():
        match = re.search(r'(?:#define\s+(\w+)|const\s+\w+\s+(\w+)\s*=).*//\s*\[([^]]+)\]', line)
        if match:
            allowed[match[1] or match[2]] = match[3].split()
    profiles = {name: dict(token.split('=', 1) for token in values.split())
                for name, values in re.findall(r'^profile\.(\w+)=(.*)$', text, re.M)}
    controls = set()
    for screen, elements in re.findall(r'^screen\.([^=]+)=(.*)$', text, re.M):
        if screen.startswith('PERF_') or screen == 'APPLE_SETTINGS':
            controls.update(token for token in elements.split()
                            if not token.startswith(('[', '<')))
    assert set(profiles) == {'FAST', 'BALANCED', 'CRISP'}
    for name, options in profiles.items():
        assert controls <= options.keys(), (name, 'untracked menu controls', controls - options.keys())
        for key, value in options.items():
            assert key in allowed and value in allowed[key], (name, key, value)
        # Native Iris chooses Custom when no full profile matches the changed options.
        for key in controls:
            for alternative in allowed[key]:
                if alternative == options[key]:
                    continue
                changed = dict(options, **{key: alternative})
                assert not any(all(changed.get(k) == v for k, v in other.items())
                               for other in profiles.values()), (name, key, alternative)
    for name in ['FAST']:
        assert profiles[name]['SDV_CLOUD_LAYERS'] == '1'
        assert all(profiles[name][key] == '0' for key in
                   ['WATER_REFLECTIONS', 'WET_GROUND_REFLECTIONS', 'MAX_AO', 'MAX_SUNBEAMS'])
    assert profiles['FAST']['SHADOWS'] == '1'
    assert profiles['BALANCED']['FOLIAGE_WIND'] == '1'
    assert profiles['BALANCED']['WATER_REFRACTION'] == '0'
    assert all(p['FXAA'] == '0' for p in profiles.values())
    assert 'program.shadow.enabled=false' in text
    print(f'Validated three profiles and Custom matching for {len(controls)} performance controls.')

if __name__ == '__main__':
    check()
